class Api::V1::CommentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def create
    activity_attributes = {
      reason: "Comment",
      delta: 1, #need to retrieve from points configuration
      canvas_user_id: 20, #get from params
      canvas_scoring_item_id: 1, # what is this?
      canvas_updated_at: nil, #nil for now
      body: "This is a comment"
    }
  end

end

