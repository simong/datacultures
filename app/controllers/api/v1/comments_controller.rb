class Api::V1::CommentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def create
    Comment.create({authors_canvas_id: current_user.canvas_id, gallery_id: safe_params[:id],
                    content: safe_params[:comment] })
    head :created
  end

  def update
    Comment.find(safe_params[:comment_id]).update_attributes({
        content: safe_params[:comment] })
    head :ok
  end

  private

  def safe_params
    params.permit(:id, :comment, :comment_id)
  end
end

