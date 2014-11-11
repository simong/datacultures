class Api::V1::LikesController < ApplicationController

  layout false
  CURRENT_USER_TYPES = { true => 'Like', false => 'Dislike'}
  ORIGINAL_POSTER_TYPE = { true => 'GetALike', false => 'GetADislike'}

  # POST /api/v1/likes
  def create
    original_poster = posting_user_id
    if (original_poster != current_user.canvas_id)
      previous_records(user_list: [original_poster, current_user.canvas_id]).each do |previous_record|
        previous_record.retire!
      end
      if [true, false].include?(safe_params['liked'])
        Activity.score!(values_for_create(canvas_user_id: current_user.canvas_id,
                                          activity_name: like_type(user_type: 'CurrentUser')))
        Activity.score!(values_for_create(canvas_user_id: original_poster,
                                          activity_name: like_type(user_type: 'OriginalPoster')))
      end
      head :created
    else
      head :forbidden
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def safe_params
      params.permit(:liked, :id)
    end

    def values_for_create(canvas_user_id:, activity_name:)
      {
          canvas_user_id: canvas_user_id,
          reason: activity_name,
          scoring_item_id: safe_params['id'],
          canvas_updated_at: Time.now,
          delta: PointsConfiguration.cached_mappings[activity_name],
          score: PointsConfiguration.active_flag_mappings[activity_name]
      }
    end

    def like_type(user_type:)
      user_mapping = (user_type == 'CurrentUser') ? CURRENT_USER_TYPES : ORIGINAL_POSTER_TYPE
      user_mapping[safe_params['liked']]
    end

    def posting_user_id
      if safe_params[:id] =~ /image-/
        model = Attachment
      else
        model = MediaUrl
      end
      model.where(gallery_id: safe_params[:id]).first.try(:canvas_user_id)
    end

    def previous_records(user_list:)
      Activity.current.where(reason: ['Like', 'Dislike'],
                     scoring_item_id: safe_params['id'],
                     canvas_user_id: user_list)
    end

end
