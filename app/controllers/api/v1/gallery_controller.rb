class Api::V1::GalleryController < ApplicationController

  require 'hash_refinement'
  using HashRefinement

  COMMON_QUERY=<<-END_OF_COMMON_QUERY
    LEFT JOIN (SELECT com.gallery_id AS comm_gallery_id, count(*) AS comment_count
    FROM comments com GROUP BY com.gallery_id) as co ON g.gallery_id = comm_gallery_id
    INNER JOIN students s ON s.canvas_user_id = g.canvas_user_id
    LEFT JOIN views v ON v.gallery_id = g.gallery_id
    LEFT JOIN (SELECT act.scoring_item_id, count(*) AS likes FROM activities act
      WHERE   act.expired = 'f' AND  act.reason = 'Like'  GROUP BY act.scoring_item_id )
      AS li ON li.scoring_item_id = g.gallery_id
    LEFT JOIN (SELECT act.scoring_item_id, count(*) AS dislikes FROM activities act
      WHERE act.expired = 'f' AND reason = 'Dislike' GROUP BY act.scoring_item_id)
      AS dli ON dli.scoring_item_id = g.gallery_id
    LEFT JOIN (SELECT true AS liked, scoring_item_id FROM activities act WHERE act.canvas_user_id = %s
      AND act.reason = 'Like') AS is_liked ON is_liked.scoring_item_id = g.gallery_id
    LEFT JOIN (SELECT true AS disliked, scoring_item_id FROM activities act WHERE act.canvas_user_id = %s
      AND act.reason = 'Dislike') AS is_disliked ON is_disliked.scoring_item_id = g.gallery_id
  END_OF_COMMON_QUERY

  IMAGE_SPECIFIC_QUERY =<<-END_OF_IMAGE_QUERY
    SELECT 'image' AS type, likes, dislikes, liked, disliked, g.assignment_id, g.submission_id, g.attachment_id,
      s.name AS author, g.gallery_id AS id, g.canvas_user_id, g.content_type, co.comment_count, v.views
      FROM attachments g
  END_OF_IMAGE_QUERY

  VIDEO_SPECIFIC_QUERY=<<-END_OF_VIDEO_QUERY
    SELECT 'video' AS type, likes,  dislikes, liked, disliked, g.canvas_assignment_id AS assignment_id, g.site_tag, g.site_id,
      s.name AS author, g.gallery_id AS id, g.canvas_user_id, co.comment_count, v.views
      FROM media_urls g
  END_OF_VIDEO_QUERY

  COMMENTS_QUERY = <<-END_OF_COMMENTS_QUERY
    SELECT c.content AS comment, c.id AS comment_id,
      c.authors_canvas_id AS author_canvas_user_id, cast(extract(EPOCH from c.created_at)* 1000 AS bigint) AS created_at,
      s.name AS author_name from comments c INNER JOIN students s ON s.canvas_user_id = c.authors_canvas_id
      WHERE c.gallery_id = '%s'
  END_OF_COMMENTS_QUERY

  SINGLE_ITEM_RESTRICTION =  %q< WHERE g.gallery_id = '%s'; >

  IMAGE_QUERY = IMAGE_SPECIFIC_QUERY + COMMON_QUERY
  VIDEO_QUERY = VIDEO_SPECIFIC_QUERY + COMMON_QUERY

  # GET /api/v1/gallery/index.json
  def index
    if current_user.canvas_id
      json =  sql_query(query: VIDEO_QUERY % [me, me]).map{|v| v.video_transform!} +
              sql_query(query: IMAGE_QUERY % [me, me]).map{|i| i.image_transform!}
      render json: {'files' => json}, layout: false
    else
      head :forbidden
    end
  end

  # GET /api/v1/gallery/:gallery_id
  def show
    if current_user.canvas_id
      case safe_params[:gallery_id]
        when /\Aimage-/                                        # anchor for performance
          base_data = image_item_data.first.image_transform!
        when /\Avideo-/
          base_data = video_item_data.first.video_transform!
        else
          base_data = {}
      end
      comments  = item_comments
      json      = base_data.merge({ 'comments' => comments })
      render json: json, layout: false
    else
      head :forbidden
    end
  end

  private

  def safe_params
    params.permit(:gallery_id)
  end

  def sql_query(query:)
    ActiveRecord::Base.connection.execute(query).to_a
  end

  def video_item_data
     sql_query(query: (VIDEO_QUERY + SINGLE_ITEM_RESTRICTION) % [me, me, safe_params[:gallery_id]])
  end

  def image_item_data
    sql_query(query: (IMAGE_QUERY + SINGLE_ITEM_RESTRICTION) % [me, me, safe_params[:gallery_id]])
  end

  def item_comments
    comments_query = COMMENTS_QUERY % safe_params[:gallery_id]
    sql_query(query: comments_query)
  end

  def me
    current_user.canvas_id
  end

end
