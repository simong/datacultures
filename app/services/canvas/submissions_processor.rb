class Canvas::SubmissionsProcessor

  attr_accessor :request_object, :submission, :course

  def initialize(conf)
    @request_object  = conf[:request_object]      # TODO: remove if this scoring is good.
    @submission      = PointsConfiguration.where({interaction: 'Submission'}).first
    @course          = Rails.application.secrets['requests']['course']
  end

  def call(stream_entry)

    assignment = stream_entry['assignment']
    if assignment && assignment['id']   # without an assignment, there's no way to score this item => NO OP
       user_id    = stream_entry['user_id']
       assignment_id = assignment['id']
       if user_id                       # without a user, we can't do anything
         scoring_record = Activity.where({canvas_scoring_item_id: assignment_id, canvas_user_id:  user_id,
                                          reason: 'Submission'}).order('updated_at DESC').first
         if scoring_record.nil?
           Activity.score!({canvas_scoring_item_id: assignment_id, canvas_user_id: user_id, reason: 'Submission',
                            delta: submission.points_associated,   canvas_updated_at: stream_entry['updated_at'] })
         end
       end
    end

  end

end
