class Api::V1::GalleryController < ApplicationController

  require 'array_refinement'
  using ArrayRefinement

  # GET /api/v1/gallery/index.json
  IMAGE_ATTRIBUTES = ['id','canvas_user_id','assignment_id','submission_id','attachment_id', 'author','date','content_type','image_url', 'gallery_id']
  VIDEO_ATTRIBUTES = ['id', 'created_at', 'site_tag', 'site_id', 'canvas_user_id', 'canvas_assignment_id', 'author', 'gallery_id', 'thumbnail_url']
  def index
    image_json = Attachment.includes(:comments, :view).select(IMAGE_ATTRIBUTES).to_a.image_hash
    video_json = MediaUrl.includes(:comments).select(VIDEO_ATTRIBUTES).to_a.video_hash
    dislike_counts = Activity.dislike_totals
    like_counts = Activity.like_totals
    json = image_json + video_json
    json.each do |item|
      item['likes']    =    like_counts[item['id']] || 0
      item['dislikes'] = dislike_counts[item['id']] || 0
      item['liked']    =     user_likes[item['id']]
    end
    render json: {'files' => json}, layout: false
  end

  def user_likes(user_id = current_user.canvas_id)
    likes    = Activity.where({canvas_user_id:  user_id, reason: 'Like'}).
        select('scoring_item_id').map{|activity| activity.scoring_item_id}
    dislikes = Activity.where({canvas_user_id:  user_id, reason: 'Dislike'}).
        select('scoring_item_id').map{|activity| activity.scoring_item_id}
    likes_hash = {}
    likes.each{ |id| likes_hash[id] = true }
    dislikes.each{ |id|likes_hash[id] = false }
    likes_hash
  end

end
