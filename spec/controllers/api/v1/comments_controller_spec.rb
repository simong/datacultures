require 'rails_helper'

RSpec.describe Api::V1::CommentsController, :type => :controller do

  let(:valid_comment_json) {
    {
      id: 10,
      comment: "This is a practice comment"
    }
  }

  before(:all) do
    PointsConfiguration.delete_all
    Activity.delete_all
    PointsConfiguration.create({interaction: "GalleryComment", points_associated: 7,
                                active: true, pcid: 3})
  end

  # describe "POST update" do
  #
  #   before(:all) do
  #     FactoryGirl.create(:student, name: 'Ford Prefect of the Comments Controller', canvas_user_id: 5)
  #   end
  #
  #   after(:all) do
  #     Student.delete_all
  #   end
  #
  #   before(:each) do
  #     #allow(controller).to receive(:current_user).and_return(USER_STRUCT)
  #   end
  #
  #   it "creates a comment when submitted to with valid params" do
  #    # allow(controller).to receive(:current_user).and_return(USER_STRUCT)
  #     expect{
  #       post :create, valid_comment_json
  #     }.to change(Comment, :count).by(1)
  #   end
  #
  #   it "responds with a 400 with invalid params" do
  #     valid_comment_json.delete(:attachment_id)
  #     post :create, valid_comment_json
  #     expect(response.response_code).to eq(400)
  #   end
  #
  #   it "does not create a new object with invalid params" do
  #     expect{
  #       valid_comment_json.delete(:attachment_id)
  #       post :create, valid_comment_json
  #     }.to change(Comment, :count).by(0)
  #   end
  #
  # end

end
