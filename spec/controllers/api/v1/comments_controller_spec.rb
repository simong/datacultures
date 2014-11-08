require 'rails_helper'

RSpec.describe Api::V1::CommentsController, :type => :controller do

  let(:valid_create_comment_json) {
    {
      id: '10',
      comment: "This is a practice comment"
    }
  }

  let(:valid_update_comment_json) {
    {
        comment: 'Some comment value',
        comment_id: 100
    }
  }

  before(:all) do
    PointsConfiguration.delete_all
    Activity.delete_all
    PointsConfiguration.create({interaction: "GalleryComment", points_associated: 7,
                                active: true, pcid: 3})
    FactoryGirl.create(:student, name: 'Ford Prefect of the Comments Controller', canvas_user_id: 5)
  end

  after(:all) do
    Student.delete_all
    Activity.delete_all
    Comment.delete_all
    PointsConfiguration.delete_all
  end

  before(:each) do
    allow(controller).to receive(:current_user).and_return(USER_STRUCT)
  end

  describe "POST create" do

    it "creates a comment when submitted to with valid params" do
      expect{
        post :create, valid_create_comment_json
      }.to change(Comment, :count).by(1)
    end

    it "responds with a 400 with invalid params" do
      valid_create_comment_json.delete(:id)
      post :create, valid_create_comment_json
      expect(response.response_code).to eq(400)
    end

    it "does not create a new object with invalid params" do
      expect{
        valid_create_comment_json.delete(:id)
        post :create, valid_create_comment_json
      }.to change(Comment, :count).by(0)
    end

    it "scores for the student posting" do
      expect {
        post :create, valid_create_comment_json
      }.to change{Activity.student_scores}
    end

    it "scores for the base item's poster if not also the commenter" do
      attachment = FactoryGirl.create(:attachment, canvas_user_id: 17)
      expect{
        post :create, { 'comment' => 'testing', 'id' => attachment.gallery_id }
      }.to change{Activity.student_scores[17]}
    end

    it "does not score for the commenter if s/he also posted the base item" do
      attachment = FactoryGirl.create(:attachment, canvas_user_id: USER_STRUCT.canvas_id)
      expect{
        post :create, { 'comment' => 'testing', 'id' => attachment.gallery_id }
      }.to_not change{Activity.student_scores[USER_STRUCT.canvas_id]}
    end

  end

  describe "PUT update" do

    it "returns '410 GONE' if not passed in a valid comment_id"  do
      put :update, valid_update_comment_json
      expect(response.status).to have_return_status :gone
    end

    it "updates the comment if given a valid comment_id" do
      comment = Comment.create({gallery_id: 'FOO', authors_canvas_id: 5, content: 'Original Comment'})
      put :update, valid_update_comment_json.merge({ comment_id: comment.id, comment: 'Changed Comment'})
      expect(response.status).to have_return_status :no_content
    end

  end

end
