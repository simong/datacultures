class Canvas::DiscussionEntriesProcessor

  attr_accessor :request_object, :discussion_entry, :course

  def initialize(conf)
    @request_object     = conf[:request_object] || ApiRequest.new(api_key: conf['api_key'], base_url: conf['base_url'])
    @discussion_entry   = PointsConfiguration.where({interaction: 'DiscussionEntry'}).first
    @course             = conf['course'] || AppConfig::CourseConstants.course
  end

  def call(entries)
    # get the entries stream, score those not already scored.
    replies = Activity.where({reason: 'DiscussionEntry'}).select(:scoring_item_id)
    scored_canvas_ids = replies.collect{|a|a.scoring_item_id}
    canvas_student_ids = Student.get_students_by_canvas_id.keys
    if entries.respond_to?(:each)
      entries.each do |entry|
        ## TODO: paginate if need be, for all subentries.  This will require more API requests so long as need be.
        #      the scoring loop below can be extracted out to a method;
        #      and another method will be called if ['has_more_entries'] is set
        entries_and_subentries = [entry]   + (entry['recent_replies'] || [])
        entries_and_subentries.each do |e|
          author_id = e && e['user_id']
          if (author_id && !canvas_student_ids.include?(author_id.to_i))
            Student.create_by_canvas_user_id(author_id)
            canvas_student_ids << author_id.to_i
          end
          unless !(['id', 'user_id', 'updated_at'].all?{|k| e.key?(k) }) || scored_canvas_ids.include?(e['id'].to_s)
            Activity.score!({reason: 'DiscussionEntry', delta: discussion_entry.points_associated,
                             canvas_updated_at: e['updated_at'], body: e['message'], score: discussion_entry.active,
                             scoring_item_id: e['id'], canvas_user_id: e['user_id'] })
          end
        end
      end
    end
  end

end
