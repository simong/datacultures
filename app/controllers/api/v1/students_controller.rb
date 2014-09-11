class Api::V1::StudentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def show
    render json: Activity.where(reason: ['Like', 'Dislike','MarkNeutral'], canvas_user_id: student_params[:canvas_id]).
      select([:canvas_scoring_item_id, :reason]).as_json.inject({}) \
    {|memo, h|  memo.merge!({h['canvas_scoring_item_id'] => h['reason']})}
  end

  def update
    if params[:status].nil?
      render :nothing => true, :status => 400 #incorrect request, no params
      return
    end
    student = Student.where({canvas_user_id: params[:canvas_id]}).first
    student[:share] = params[:status]
    student.save!
    head :ok
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.permit(:canvas_id)
  end

end
