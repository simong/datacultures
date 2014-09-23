class Api::V1::UserInfoController < ApplicationController

  # GET /api/v1/user_info/me
  def show
    current_user_info = {
      canvas_user_id:  session[:canvas]['user_id'],
      canvas_username: session[:canvas]['user_name'],
      canvas_roles:    session[:canvas]['user_roles']
       }
    render json: current_user_info, layout: false
  end

end
