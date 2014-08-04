class Api::V1::StudentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def update
    if params[:status].nil?
      render :nothing => true, :status => 400 #incorrect request, no params
      return
    end
    student = Student.where({canvas_user_id: params[:c_id]}).first
    student[:share] = params[:status]
    student.save!
    head :ok
  end

end
