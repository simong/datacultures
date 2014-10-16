class Api::V1::GalleryController < ApplicationController

  # GET /api/v1/gallery/index.json
  GALLERY_UI_ATTRIBUTES = ['id','canvas_user_id','assignment_id','submission_id','attachment_id', 'author','date','content_type','url']
  def index
    image_json = Attachment.select(GALLERY_UI_ATTRIBUTES).to_a.map(&:serializable_hash)
    video_json = MediaUrl.hash_for_api
    json = image_json + video_json
    render json: {'files' => json}, layout: false
  end

end
