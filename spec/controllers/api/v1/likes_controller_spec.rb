require 'rails_helper'

RSpec.describe Api::V1::LikesController, :type => :controller do

  let!(:valid_api_params)           { { id: 'image-19', canvas_user_id: 5, liked: 'true'                            } }
  let!(:valid_db_params)            { { canvas_user_id: 5, reason: 'Like', delta: 17, scoring_item_id: 'image-19'  } }
  let!(:submission_activity_params) { {  canvas_user_id: 9, gallery_id: 'image-19'  } }

  let!(:valid_session) { {} }

  let!(:like_config) { FactoryGirl.create(:points_configuration, {interaction: 'Like', points_associated: 5})}
  let!(:dislike_config) { FactoryGirl.create(:points_configuration, {interaction: 'Dislike', points_associated: 3})}
  let!(:neutral) { FactoryGirl.create(:points_configuration, {interaction: 'MarkNeutral', points_associated: 0})}

  describe "POST create_or_update" do

    context "Validly formed call, no previous record, sufficient params" do

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

      it "Adds the poster's ID to the Activity record" do
        Activity.delete_all
        FactoryGirl.create(:attachment, submission_activity_params) # the after_create overwrites specificed gallery_id
        Attachment.first.update_attribute(:gallery_id, submission_activity_params[:gallery_id])
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create_or_update, valid_api_params, valid_session
        expect(Activity.opinion.first.posters_canvas_id).to eq(submission_activity_params[:canvas_user_id])
      end

      context "Liking one's own work" do

        before (:each) do
          Activity.delete_all
          Attachment.delete_all
          FactoryGirl.create(:attachment, { canvas_user_id: 5, gallery_id: 'image-19' })
          Attachment.first.update_attribute(:gallery_id, submission_activity_params[:gallery_id])  # 'correct' generated ID
          allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        end

        it "does not credit the poster for liking his/her own work " do
          expect{post :create_or_update, valid_api_params, valid_session}.to_not change{Activity.student_scores[5]}
        end

        it "returns a forbidden status" do
          post :create_or_update, valid_api_params, valid_session
          expect(response.status).to have_return_status :forbidden
        end

      end

    end

    context "Valid call, Activity exists for this action" do

      it "modifies the Activity record" do
        Activity.delete_all
        FactoryGirl.create(:activity, valid_db_params)
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create_or_update, valid_api_params.merge({liked: false}), valid_session
        expect(Activity.first.reason).to eq('Dislike')
      end

      it "returns 'no content'" do
        Activity.delete_all
        FactoryGirl.create(:activity, valid_db_params)
        allow(controller).to receive(:current_user).and_return(USER_STRUCT)
        post :create_or_update, valid_api_params.merge({like: false}), valid_session
        expect(response.status).to have_return_status :no_content
      end
    end

  end
end
