class Canvas::DiscussionTopicsProcessor

  attr_accessor :request_object, :top_level_post, :edit_post, :reply_to_post, :course

  def initialize(conf)
    @request_object  = conf[:request_object]
    @top_level_post  = PointsConfiguration.where({interaction: 'DiscussionTopic'}).first
    @edit_post       = PointsConfiguration.where({interaction: 'DiscussionEdit'}).first
    @course          = conf[:course] || AppConfig::CourseConstants.course
  end

  def call(discussions)

    if discussions.respond_to?(:each)
      discussions.each do |discussion|

        ## API return data might be 'dirty'
        msg = discussion['message'] || ''
        title = discussion['title'] || ''
        discussion_id = discussion['id']   # discussion's ID, not author's
        base_params = { canvas_updated_at: discussion['last_reply_at'], body: msg + title, canvas_scoring_item_id: discussion_id  }
        previous_scoring_record = Activity.where({canvas_scoring_item_id: discussion_id, reason: ['DiscussionTopic', 'DiscussionEdit']}).order('updated_at DESC').first

        if previous_scoring_record
          # we can only tell if this top-level entry was edited from comparing the message values,
          ##  as the updated_at is changed whenever there are child-level changes
          process_entries =  (previous_scoring_record.canvas_updated_at < discussion['last_reply_at'])
          if  ((discussion['message'].to_s + discussion['title'].to_s) != previous_scoring_record.body)  # edit, even trivial ones
            Activity.score!(base_params.merge({ canvas_user_id: previous_scoring_record.canvas_user_id,
                                                score: edit_post.active,
                                                reason: 'DiscussionEdit', delta: edit_post.points_associated}) )
          end
        else   # new post
          process_entries = true   # post is new, so last_reply_at is irrelevant -- always check for children
          if (discussion['author'] && discussion['author']['id'])
            author_id = discussion['author']['id']
            Activity.score!(base_params.merge({ reason: 'DiscussionTopic', delta: top_level_post.points_associated,
                                                score: top_level_post.active,
                                                canvas_user_id: author_id}))
          end
        end

        ## if there are replies to this discussion_topic
        if (discussion["discussion_subentry_count"]  > 0) && process_entries
          request_path = 'api/v1/courses/'+course.to_s+'/discussion_topics/'+discussion_id.to_s+'/entries?per_page=250'
          entry_processor  = Canvas::DiscussionEntriesProcessor.new({request_object: request_object})
          paged_processor = Canvas::PagedApiProcessor.new({ handler: entry_processor })
          paged_processor.call(request_path)
        end
      end
    end

  end

end
