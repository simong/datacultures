require 'rails_helper'

HTTP_SYMBOLS = {conflict: 409, created: 201, gone: 410, no_content: 204}

RSpec::Matchers.define :have_return_status do |expected|
  match do |actual|
    actual == HTTP_SYMBOLS[expected]
  end
end

RSpec.describe Api::V1::LikesController, :type => :controller do

  let!(:valid_params)  { {canvas_scoring_item_id: 7, canvas_user_id: 9, reason: "Like", delta: 33}  }

  let!(:valid_session) { {} }

  let!(:like_config) { FactoryGirl.create(:points_configuration, {interaction: 'Like', points_associated: 5})}
  let!(:dislike_config) { FactoryGirl.create(:points_configuration, {interaction: 'Dislike', points_associated: 3})}
  let!(:neutral) { FactoryGirl.create(:points_configuration, {interaction: 'MarkNeutral', points_associated: 0})}

  describe"GET index" do

    it "returns a JSON hash of results" do |item|
      get :index
      expect(JSON.parse(response.body)).to be_kind_of Hash
    end

    it "has Like' and 'Dislike' keys" do
      get :index
      expect(JSON.parse(response.body).keys.sort).to eq ['Dislike', 'Like']
    end

  end


  describe "POST create" do

    context "Invalid call, the record already exists" do

      it "returns an error if a record exists" do
        FactoryGirl.create :activity, valid_params
        post :create, {item: valid_params}, valid_session
        expect(response.status).to have_return_status :conflict
      end

      it "does not create an Activity record if one exists" do
        FactoryGirl.create :activity, valid_params
        expect{post :create,  {item: valid_params}, valid_session}.to_not change{Activity.count}
      end

    end

    context "Valid call, has not been liked before, and sufficient params" do

      it "indicates that a resource was created" do
        Activity.delete_all   # just in case
        post :create, {item: valid_params}, valid_session
        expect(response.status).to have_return_status :created
      end

      it "adds an Activity record" do
        Activity.delete_all   # just in case
        expect{post :create, {item: valid_params}, valid_session}.to change{Activity.count}.by(1)
      end

    end
  end

  context "PUT update" do

    context "Invalid all, resource does not exist" do

      it "returns gone when the resource does not exist" do
        Activity.delete_all
        put :update, {item: valid_params}, valid_session
        expect(response.status).to have_return_status :gone
      end

    end

    context "Valid call, Activity exists for this action" do

      it "modifies the Activity record" do
        Activity.delete_all
        FactoryGirl.create :activity, valid_params
        like_params = valid_params.merge({reason: 'Dislike'})
        ## Although this code is working and changes the Activity record, the following line fails:
        ## expect{put :update, {item: like_params}, valid_session}.to change{Activity.first}

        # but this demonstrates that it works
        put :update, {item: like_params}, valid_session
        expect(Activity.first.reason).to eq('Dislike')
      end

      it "returns 'no content'" do
        Activity.delete_all
        FactoryGirl.create :activity, valid_params
        like_params = valid_params.merge({reason: 'Dislike'})
        put :update, {item: like_params}, valid_session
        expect(response.status).to have_return_status :no_content
      end
    end

  end
end
