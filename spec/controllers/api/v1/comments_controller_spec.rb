require 'rails_helper'

HTTP_SYMBOLS = {conflict: 409, created: 201, gone: 410, no_content: 204, bad_request: 400, forbidden: 403}

RSpec::Matchers.define :have_return_status do |expected|
  match do |actual|
    actual == HTTP_SYMBOLS[expected]
  end
end

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
    PointsConfiguration.create({interaction: "GalleryComment", points_associated: 7, active: true, pcid: 5})
    PointsConfiguration.create({interaction: "GetAComment", points_associated: 11, active: true, pcid: 6})
    FactoryGirl.create(:student, name: 'Ford Prefect of the Comments Controller', canvas_user_id: 5)
    FactoryGirl.create(:attachment, canvas_user_id: USER_STRUCT.canvas_id)
    FactoryGirl.create(:attachment, canvas_user_id: USER_STRUCT.canvas_id+1)
  end

  after(:all) do
    Student.delete_all
    Activity.delete_all
    Comment.delete_all
    Attachment.delete_all
    PointsConfiguration.delete_all
  end

  before(:each) do
    allow(controller).to receive(:current_user).and_return(USER_STRUCT)
  end

  let(:current_user_attachment) do
    Attachment.where(canvas_user_id: USER_STRUCT.canvas_id).first
  end

  let(:other_user_attachment) do
    Attachment.where(canvas_user_id: USER_STRUCT.canvas_id+1).first
  end

  describe "POST create" do

    it "creates a comment when submitted to with valid params" do
      expect{
        post :create, {'id' => other_user_attachment.gallery_id, 'comment' => 'bar baz'}
      }.to change(Comment, :count).by(1)
    end

    it "responds with a 400 with invalid params" do
      valid_create_comment_json.delete(:id)
      post :create, valid_create_comment_json
      expect(response.status).to have_return_status :bad_request
    end

    it "does not create a new object with invalid params" do
      expect{
        valid_create_comment_json.delete(:id)
        post :create, valid_create_comment_json
      }.to change(Comment, :count).by(0)
    end

    it "scores for the student posting" do
      expect {
        post :create,  {'id' => other_user_attachment.gallery_id, 'comment' => 'foo bar'}
      }.to change{Activity.student_scores[USER_STRUCT.canvas_id]}.from(nil).to(7)
    end

    it "does not score for the commenter if s/he also posted the base item" do
      expect{
        post :create, { 'comment' => 'testing', 'id' => current_user_attachment.gallery_id }
      }.to_not change{Activity.student_scores[current_user_attachment.canvas_user_id]}
    end

    it "score for the original poster" do
      attachment = FactoryGirl.create(:attachment, canvas_user_id: USER_STRUCT.canvas_id + 1)
      expect{
        post :create, { 'comment' => 'testing', 'id' => attachment.gallery_id }
      }.to change{Activity.student_scores[USER_STRUCT.canvas_id+1]}.from(nil).to(11)
    end

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
