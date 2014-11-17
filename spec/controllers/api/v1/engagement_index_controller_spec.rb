require 'rails_helper'

RSpec.describe Api::V1::EngagementIndexController, :type => :controller do

  let(:valid_session) { {} }

  before(:all) do
    FactoryGirl.create_list(:student, 2, {share: true})
    FactoryGirl.create(:student, {share: false})
  end

  after(:all) do
    Student.delete_all
  end

  describe "GET index" do
    it "returns all students if a teacher" do
      FactoryGirl.create(:student, {name: 'Nolan Chan', share: false})
      allow(controller).to receive(:current_user).and_return(TEACHER_STRUCT)
      get :index, {format: :json}, valid_session
      expect(JSON.parse(response.body)["students"].map{|s| s['name']}).to include("Nolan Chan")
    end

    it "returns three students when three students sharing are in the Database" do
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      FactoryGirl.create(:student, {canvas_user_id: USER_STRUCT.canvas_id, share: true})
      get :index, {format: :json}, valid_session
      expect(JSON.parse(response.body)["students"].count).to eq(3)
    end

    it "only shows the current student if s/he is not sharing" do
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      FactoryGirl.create(:student, {canvas_user_id: USER_STRUCT.canvas_id, share: false})
      get :index, {format: :json}, valid_session
      expect(JSON.parse(response.body)["students"].count).to eq(1)
    end
  end

end
