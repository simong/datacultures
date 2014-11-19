require 'rails_helper'

RSpec.describe Api::V1::LikesController, :type => :controller do

  let!(:valid_api_params)           { { id: 'image-19', canvas_user_id: 5, liked: true                             } }
  let!(:valid_unlike_api_params)    { { id: 'image-19', canvas_user_id: 5, liked: nil                              } }
  let!(:valid_db_params)            { { canvas_user_id: 5, reason: 'Like', delta: 17, scoring_item_id: 'image-19'  } }

  let!(:valid_session) { {} }



  describe "POST create" do

    before(:all) do
      PointsConfiguration.delete_all
      FactoryGirl.create(:points_configuration, {interaction: 'Like', points_associated: 5})
      FactoryGirl.create(:points_configuration, {interaction: 'Dislike', points_associated: 3})
      FactoryGirl.create(:points_configuration, {interaction: 'GetADislike', points_associated: 3})
      FactoryGirl.create(:points_configuration, {interaction: 'GetALike', points_associated: 5})
      Attachment.delete_all
      @submission_activity_params = {  canvas_user_id: 9, gallery_id: 'image-19'  }
      @attachment = FactoryGirl.create(:attachment, @submission_activity_params) # the after_create overwrites specificed gallery_id
      @attachment.update_attribute(:gallery_id, @submission_activity_params[:gallery_id])
    end

    after(:all) do
      Attachment.delete_all
      PointsConfiguration.delete_all
      Activity.delete_all
    end

    context "Validly formed call" do

      it "indicates that a resource was created" do
        Activity.delete_all   # just in case
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create, valid_api_params, valid_session
        expect(response.status).to have_return_status :created
      end

      it "adds two Activity records" do
        Activity.delete_all   # just in case
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        expect{post :create, valid_api_params, valid_session}.to change{Activity.count}.by(2)
      end

      it "Adds the poster's ID to the second Activity record" do
        Activity.delete_all
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create, valid_api_params, valid_session
        expect(Activity.opinion.last.canvas_user_id).to eq(@submission_activity_params[:canvas_user_id])
      end

      it "counts only one action per user per gallery item" do
        Activity.delete_all
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        expect {
          post :create, valid_api_params,        valid_session
          post :create, valid_unlike_api_params, valid_session
          post :create, valid_api_params,        valid_session
        }.to change{Activity.like_totals['image-19']}.from(nil).to(1)
        end

      context "Liking one's own work" do

        before (:each) do
          Activity.delete_all
          allow(controller).to receive(:current_user).and_return(OpenStruct.new({canvas_id: 9}))
        end

        it "does not credit the poster for liking his/her own work " do
          expect{post :create, valid_api_params, valid_session}.to_not change{Activity.student_scores[9]}
        end

        it "returns a forbidden status" do
          post :create, valid_api_params, valid_session
          expect(response.status).to be(403)
        end

      end

      it "creates an appropriate Activity record" do
        Activity.delete_all
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create, {'id' => @attachment.gallery_id, 'canvas_user_id' => 5, 'liked' => false}, valid_session
        expect(Activity.first.reason).to eq('Dislike')
      end

    end

  end
end
