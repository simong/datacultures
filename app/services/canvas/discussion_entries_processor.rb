class Canvas::DiscussionEntriesProcessor

  attr_accessor :request_object, :discussion_entry, :course

  def initialize(conf)
    @request_object     = conf[:request_object] || Canvas::ApiRequest.new({api_key: conf['api_key'], base_url: conf['base_url']})
    @discussion_entry   = PointsConfiguration.where({interaction: 'DiscussionEntry'}).first
    @course             = conf['course'] || Rails.application.secrets['requests']['course']
  end

  def call(entries)
    # get the entries stream, score those not already scored.
    replies = Activity.where({reason: 'DiscussionEntry'}).select(:canvas_scoring_item_id)
    scored_canvas_ids = replies.collect{|a|a.canvas_scoring_item_id}
    entries.each do |entry|
      ## TODO: paginate if need be, for all subentries.  This will require more API requests so long as need be.
      #      the scoring loop below can be extracted out to a method;
      #      and another method will be called if ['has_more_entries'] is set
      entries_and_subentries = [entry]   + (entry['recent_replies'] || [])
      entries_and_subentries.each do |e|
        unless !(['id', 'user_id', 'updated_at'].all?{|k| e.key?(k) }) || scored_canvas_ids.include?(e['id'])
          Activity.score!({reason: 'DiscussionEntry', delta: discussion_entry.points_associated,
                           canvas_updated_at: e['updated_at'], body: e['message'], score: discussion_entry.active,
                           canvas_scoring_item_id: e['id'], canvas_user_id: e['user_id'] })
        end
      end
    end
  end

end
