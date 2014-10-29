require 'rails_helper'

HTTP_SYMBOLS = {conflict: 409, created: 201, gone: 410, no_content: 204}

RSpec::Matchers.define :have_return_status do |expected|
  match do |actual|
    actual == HTTP_SYMBOLS[expected]
  end
end

RSpec.describe Api::V1::LikesController, :type => :controller do

  let!(:valid_api_params)  { { id: 7, canvas_user_id: 5, liked: 'true'}  }
  let!(:valid_db_params) {{ scoring_item_id: 7, canvas_user_id: 5, reason: 'Like', delta: 17      }}

  let!(:valid_session) { {} }

  let!(:like_config) { FactoryGirl.create(:points_configuration, {interaction: 'Like', points_associated: 5})}
  let!(:dislike_config) { FactoryGirl.create(:points_configuration, {interaction: 'Dislike', points_associated: 3})}
  let!(:neutral) { FactoryGirl.create(:points_configuration, {interaction: 'MarkNeutral', points_associated: 0})}

  describe "POST create_or_update" do

    context "Valid call, no previous record, sufficient params" do

      it "indicates that a resource was created" do
        Activity.delete_all   # just in case
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create_or_update, valid_api_params, valid_session
        expect(response.status).to have_return_status :created
      end

      it "adds an Activity record" do
        Activity.delete_all   # just in case
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        expect{post :create_or_update, valid_api_params, valid_session}.to change{Activity.count}.by(1)
      end

    end

    context "Valid call, Activity exists for this action" do

      it "modifies the Activity record" do
        Activity.delete_all
        FactoryGirl.create(:activity, valid_db_params)
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create_or_update, valid_api_params.merge({liked: 'false'}), valid_session
        expect(Activity.first.reason).to eq('Dislike')
      end

      it "returns 'no content'" do
        Activity.delete_all
        FactoryGirl.create(:activity, valid_db_params)
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create_or_update, valid_api_params.merge({like: 'false'}), valid_session
        expect(response.status).to have_return_status :no_content
      end
    end

  end
end
