require 'rails_helper'

RSpec.describe Api::V1::GalleryController, :type => :controller do

  let(:valid_activity_attributes) {
    {
      canvas_user_id: 1,
      reason: "Post artwork in Mission Gallery",
      delta: 15,
      scoring_item_id: 100,
      canvas_updated_at: Time.now
    }
  }

  let(:valid_session) { {} }

  before(:all) do
    students = [FactoryGirl.create(:student, canvas_user_id: 4),
                FactoryGirl.create(:student, canvas_user_id: 5),
                FactoryGirl.create(:student, canvas_user_id: 7)]
    3.times { |n| FactoryGirl.create(:attachment, {canvas_user_id: students[n].canvas_user_id})          }
    attachment_ids = Attachment.all.map(&:gallery_id)
    Activity.create({reason: 'Like', scoring_item_id: attachment_ids[0], delta: 10, canvas_user_id: 5 })
    Activity.create({reason: 'Dislike', scoring_item_id: attachment_ids[1], delta: -2, canvas_user_id: 5 })
  end


  describe 'GET index' do

    it "gives the right liked state ('false') if disliked" do
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      get :index, valid_session
      attachment_ids = Attachment.all.map(&:gallery_id)
      disliked_item = JSON.parse(response.body)['files'].detect{|gi| gi['id'] == attachment_ids[1]}
      expect(disliked_item['liked']).to  be_falsey
    end

    it "gives the right liked state ('null') for items with no activity" do
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      get :index, {format: :json}, valid_session
      attachment_ids = Attachment.all.map(&:gallery_id)
      disinterested_item = JSON.parse(response.body)['files'].detect{|gi| gi['id'] == attachment_ids[2]}
      expect(disinterested_item['liked']).to be_nil
    end

    it "returns the index, correctly showing the current user liking the first item" do
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      get :index, valid_session
      attachment_ids = Attachment.all.map(&:gallery_id)
      liked_item = JSON.parse(response.body)['files'].detect{|gi| gi['id'] == attachment_ids[0]}
      expect(liked_item['liked']).to  be_truthy
    end

    it "returns a '403 Forbidden' if no current_user is passed in" do
      get :index
      expect(response.status).to have_return_status :forbidden
    end

  end

  describe 'GET show' do

    context "it gets a proper user in the session" do

      before(:each) do
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      end

      it 'returns a single file item' do
        get :show, gallery_id: Attachment.first.gallery_id
        expect(JSON.parse(response.body)['files'].first).to have_key('comments')
      end

      it 'finds the comments on an item' do
        gallery_id = Attachment.first.gallery_id
        FactoryGirl.create(:comment, gallery_id: gallery_id, authors_canvas_id: Student.first.canvas_user_id )
        get :show, gallery_id: gallery_id
        expect(JSON.parse(response.body)['files'].first['comments'].first).to be_kind_of Hash
      end

      it 'item comments have the correct keys' do
        gallery_id = Attachment.first.gallery_id
        FactoryGirl.create(:comment, gallery_id: gallery_id, authors_canvas_id: Student.first.canvas_user_id )
        get :show, gallery_id: gallery_id
        expect(JSON.parse(response.body)['files'].first['comments'].first.keys).
            to eq(%w<comment comment_id author_canvas_id created_at author_name>)
      end

    end

    context "it does not get a user in the session" do
      it "returns a '403 Forbidden'" do
        get :index
        expect(response.status).to have_return_status :forbidden
      end

    end

  end

  after(:all) do
    Activity.delete_all
    Student.delete_all
    Attachment.delete_all
  end


end
