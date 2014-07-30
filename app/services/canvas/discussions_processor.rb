class Canvas::DiscussionsProcessor

  attr_accessor :request_object, :top_level_post, :edit_post, :reply_to_post, :course

  def initialize(conf)
    @request_object  = conf[:request_object]
    @top_level_post  = PointsConfiguration.where({interaction: 'DiscussionTopic'}).first
    @edit_post       = PointsConfiguration.where({interaction: 'DiscussionEdit'}).first
    @reply_to_post   = PointsConfiguration.where({interaction: 'DiscussionReply'}).first
    @course          = Rails.application.secrets['requests']['course']
  end

  def call(stream_entry)

    discussion_id = stream_entry['discussion_topic_id']   # discussion's ID, not author's
    base_params = { canvas_updated_at: stream_entry['updated_at'], body:  stream_entry['message'], canvas_scoring_item_id: discussion_id  }
    scoring_record = Activity.where({canvas_scoring_item_id: discussion_id, reason: ['DiscussionTopic', 'DiscussionEdit']}).order('updated_at DESC').first

    if scoring_record
      # we can only tell if this top-level entry was edited from comparing the message values,
      ##  as the updated_at is changed whenever there are child-level changes
      if edit_post.active && (stream_entry['message'] != scoring_record.body)  # edit, even trivial ones
        Activity.score!(base_params.merge({ canvas_user_id: scoring_record.canvas_user_id,
                                            reason: 'DiscussionEdit', delta: edit_post.points_associated}) )
      end
    else
      ## new post, we must get the author's ID via API call (it is NOT provided in the activity_stream call)
      request_path =  "api/v1/courses/#{course}/discussion_topics/#{discussion_id}"
      response = request_object.request.get(request_path)

      unless !top_level_post.active || response.nil? || response.body.blank? || !response.body.kind_of?(Hash) || response.body.has_key?("errors")
        author_id = response.body['author']['id']
        Activity.score!(base_params.merge({ reason: 'DiscussionTopic', delta: top_level_post.points_associated,
                                            canvas_user_id: author_id}))
      end
    end


    if reply_to_post.active && stream_entry["total_root_discussion_entries"]  && stream_entry["total_root_discussion_entries"] > 0
      request_path = 'api/v1/courses/'+course.to_s+'/discussion_topics/'+discussion_id.to_s+'/entries'
      entries = request_object.request.get(request_path)
      process_children( entries )
    end

  end

  def process_children(entries)
    # get the entries stream, score those not already scored.
    replies = Activity.where({reason: 'DiscussionReply'}).select(:canvas_scoring_item_id)
    logged_canvas_ids = replies.collect{|a|a.canvas_scoring_item_id}
    if entries    # guard against no return values (no network, or no reply from Canvas)
      entries.each do |entry|
        subentries = entry['recent_replies'] || []
        entries_and_subentries = [entry]   + subentries
        entries_and_subentries.each do |e|
          unless logged_canvas_ids.include?(e['id'])
            Activity.score!({reason: 'DiscussionReply', delta: reply_to_post.points_associated,
                             canvas_updated_at: e['updated_at'], body: e['message'],
                             canvas_scoring_item_id: e['id'], canvas_user_id: e['user_id'] })

          end
        end

      end
    end
  end
end
