class Api::V1::GalleryController < ApplicationController

  # GET /api/v1/gallery/index.json
  GALLERY_UI_ATTRIBUTES = ['id','canvas_user_id','assignment_id','submission_id','attachment_id', 'author','date','content_type','url']
  def index
    json = Attachment.select(GALLERY_UI_ATTRIBUTES).to_a.map(&:serializable_hash)
    json << Student.where({canvas_user_id: session[:canvas_user_id].to_i}).first
    render json: {'files' => json}, layout: false
  end

end
