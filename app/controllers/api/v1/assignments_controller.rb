class Api::V1::AssignmentsController < ApplicationController

  def index
    # remove 'id' -- we don't care that's local (not relevant to canvas assignment IDs)
    render json: Assignment.select(:name, :canvas_assignment_id).map(&:serializable_hash).map{|a| a.slice('name', 'canvas_assignment_id')}
  end

end
