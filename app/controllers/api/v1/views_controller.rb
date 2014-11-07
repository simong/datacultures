class Api::V1::ViewsController < ApplicationController

  # POST :create_or_update
  def increment
    view = View.find_or_create_by({gallery_id: safe_params[:gallery_id]})
    view.update_attribute(:views, view.views + 1)
    head :ok
  end

  private

  def safe_params
    params.permit(:gallery_id)
  end

end
