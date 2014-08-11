require 'rails_helper'

RSpec.describe Api::V1::CommentsController, :type => :controller do

  let(:valid_parent_comment_attributes) {
    {
      title: "Practice Comment",
      parent_id: nil,
      comment_id: 0,
      content: "This is a practice comment",
      submission_id: 0,
      authors_canvas_id: 123
    }
  }

  let(:valid_child_comment_attributes) {
    {
      title: "Practice Comment",
      parent_id: 0,
      comment_id: 1,
      content: "This is a practice comment",
      submission_id: 0,
      authors_canvas_id: 123
    }
  }

  let(:valid_session) { {} }

  describe "POST update" do
    it "responds with a 200 with valid params" do
      post :create, valid_parent_comment_attributes
      expect(response.response_code).to eq(200)
    end

    # it "changes the status correctly of the student" do
    #   student = Student.create! valid_student_attributes
    #   post :update, :status => true, :canvas_id => "1"
    #   changed_student = Student.where({canvas_user_id: 1})[0]
    #   expect(changed_student[:share]).to eq(true)
    # end

    # it "should respond with a 400 when the params are malformed" do
    #   student = Student.create! valid_student_attributes
    #   post :update, :canvas_id => "1"
    #   expect(response.response_code).to eq(400)
    # end

  end

end
