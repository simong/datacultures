class Api::V1::CommentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def create
    if params["thread"] #It is a child comment
      comment_attributes = {
        title: params["thread"].last["title"],
        parent_id: params["commentID"],
        comment_id: params["thread"].length, #will be unique, as it return the current number of replies (assuming no deletes)
        content: params["thread"].last["content"],
        submission_id: params["photoID"],
        authors_canvas_id: session[:canvas_user_id]
      }
    else #It is a parent comment
      comment_attributes = {
        title: params["title"],
        parent_id: nil,
        comment_id: params["commentID"],
        content: params["content"],
        submission_id: params["photoID"],
        authors_canvas_id: session[:canvas_user_id]
      }
    end
    comment =  Comment.find_or_create_by comment_attributes
    puts "The ID is " + comment.id.to_s
    activity_attributes = {
      reason: "GalleryComment",
      delta: 1, #PointsConfiguration.where({interaction: 'GalleryComment'}).first,
      canvas_user_id: session[:canvas_user_id],
      canvas_scoring_item_id: comment.id,
      canvas_updated_at: nil,
      body: comment.content
    }
    Activity.score! activity_attributes
    head :ok
  end

end

