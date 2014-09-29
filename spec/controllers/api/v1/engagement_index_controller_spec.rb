require 'rails_helper'

RSpec.describe Api::V1::EngagementIndexController, :type => :controller do

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

  describe "GET index" do
    it "responds with a JSON" do
      activity = Activity.create! valid_activity_attributes
      student = Student.create! valid_student_attributes
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      get :index, {format: :json}, valid_session
      expect(JSON.parse(response.body)["students"][0]["name"]).to eq("Nolan Chan")

    end

    it "returns two students when two students are in the Database" do
      FactoryGirl.create(:student, canvas_user_id: 2)
      FactoryGirl.create(:activity, canvas_user_id: 2)
      activity = Activity.create! valid_activity_attributes
      student = Student.create! valid_student_attributes
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      get :index, {format: :json}, valid_session
      expect(JSON.parse(response.body)["students"].count).to eq(2)
    end
  end

end
