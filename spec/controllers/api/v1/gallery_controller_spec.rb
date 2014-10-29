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

  describe 'GET index' do

    before(:all) do
      students = [FactoryGirl.create(:student, canvas_user_id: 4),
                  FactoryGirl.create(:student, canvas_user_id: 5),
                  FactoryGirl.create(:student, canvas_user_id: 7)]
      FactoryGirl.create_list(:attachment, 3)
      attachment_ids = Attachment.all.select(:id, :assignment_id).map{|a| a.assignment_id.to_s + '-' + a.id.to_s}
      Activity.create({reason: 'Like', scoring_item_id: attachment_ids[0], delta: 10, canvas_user_id: 4 })
      Activity.create({reason: 'Dislike', scoring_item_id: attachment_ids[1], delta: -2, canvas_user_id: 5 })
    end

    it "gives the right liked state ('disliked')" do
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      get :index, {format: :json}, valid_session
      attachment_ids = Attachment.all.select(:id, :assignment_id).map{|a| a.assignment_id.to_s + '-' + a.id.to_s}
      disliked_item = JSON.parse(response.body)['files'].detect{|gi| gi['id'] == attachment_ids[1]}
      expect(disliked_item['liked']).to  eq('false')
    end

    it "gives the right liked state ('null') for items with no activity" do
      allow(controller).to receive(:current_user).and_return(USER_STRUCT)
      get :index, {format: :json}, valid_session
      attachment_ids = Attachment.all.select(:id, :assignment_id).map{|a| a.assignment_id.to_s + '-' + a.id.to_s}
      disinterested_item = JSON.parse(response.body)['files'].detect{|gi| gi['id'] == attachment_ids[0]}
      expect(disinterested_item['liked']).to  eq('null')
    end


    after(:all) do
      Activity.delete_all
      Student.delete_all
      Attachment.delete_all
    end

  end

end
