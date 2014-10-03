class Api::V1::CommentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def show
    # use attachment_id to pull -- one call per gallery item
    comments_json = []
    comments = Comment.where({attachment_id: params[:attachment_id]})
    parent_comments = comments.where({parent_id: -1}).order(updated_at: :asc)
    child_comments = comments.where.not({parent_id: -1}).order(created_at: :asc)
    parent_comments.each do |comment|
      direct_child_comments = child_comments.where({parent_id: comment.comment_id}).order(comment_id: :asc)
      comment_hash = comment.attributes
      comment_hash["thread"] = direct_child_comments.map{|c| c.attributes}
      comments_json << comment_hash
    end
    render json: comments_json
  end
    #pull out posts that have no parents
    #for each post, pull outs post that have this post as parent

  def create
    author = Student.where({canvas_user_id: current_user.canvas_id}).first
    comment_attributes = {
        authors_canvas_id: current_user.canvas_id,
        attachment_id: params["attachment_id"],
        content: params["content"],
        author: author.name,
        parent_id: -1
    }
    if params["parent_id"] #It is a child comment
      comment_attributes[:parent_id] =  params["parent_id"]
    end
    comment =  Comment.new comment_attributes
    comment_configuration = PointsConfiguration.where({interaction: 'GalleryComment'}).first
    if comment.save
      Activity.score! ({ reason: "GalleryComment", delta: comment_configuration.points_associated,
                         canvas_user_id: current_user.canvas_id,
                         canvas_scoring_item_id: params['attachment_id'], score: comment_configuration.active,
                         canvas_updated_at: Time.now, body: comment.content})
      head :created
    else
      render :nothing => true, :status => 400
    end
  end
end

