require 'rails_helper'

RSpec.describe Api::V1::StudentsController, :type => :controller do

  let(:valid_student_attributes) {
    {
      canvas_user_id: 1,
      name: "Nolan Chan",
      sortable_name: "Chan, Nolan",
      sis_user_id: "1234",
      primary_email: "nolanchan@berkeley.edu",
      section: "A",
      share: false
    }
  }

  let(:valid_activity_attributes) {
    {
      canvas_user_id: 1,
      reason: "Post artwork in Mission Gallery",
      delta: 15,
      canvas_scoring_item_id: 100,
      canvas_updated_at: Time.now
    }
  }

  let(:valid_session) { {} }

  describe "POST update" do
    it "responds with a 200 with valid params" do
      student = Student.create! valid_student_attributes
      post :update, :status => true, :c_id => "1"
      expect(response.response_code).to eq(200)
    end

    it "changes the status correctly of the student" do
      student = Student.create! valid_student_attributes
      post :update, :status => true, :c_id => "1"
      changed_student = Student.where({canvas_user_id: 1})[0]
      expect(changed_student[:share]).to eq(true)
    end

    it "should respond with a 400 when the params are malformed" do
      student = Student.create! valid_student_attributes
      post :update, :c_id => "1"
      expect(response.response_code).to eq(400)
    end

  end

end
