class Api::V1::UserInfoController < ApplicationController

  # GET /api/v1/user_info/me
  def show
    current_user_info = {
      canvas_user_id:  current_user.canvas_id.to_i,
      canvas_username: current_user.user_name,
      canvas_roles:    current_user.user_roles
       }
    render json: current_user_info, layout: false
  end

end
