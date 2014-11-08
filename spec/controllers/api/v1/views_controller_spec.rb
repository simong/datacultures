require 'rails_helper'

RSpec.describe Api::V1::ViewsController, :type => :controller do

  let(:post_params) { { gallery_id: 'picture-2-300' } }
  let(:valid_session) { {} }

  describe "POST increment" do

    context "When a view exists" do

      it "indicates that a resource was created" do
        post :increment, post_params, valid_session
        expect(response.response_code).to eq(200)
      end

      it "adds an View record if none associated" do
        View.delete_all   # just in case
        expect{post :increment, post_params, valid_session}.to change{View.count}.by(1)
      end

      it "Increases the view count" do
        View.delete_all
        v = View.create(post_params)
        post :increment, {gallery_id: v.gallery_id }, valid_session
        expect{v.reload}.to change{v.views}.by(1)
      end
    end

  end
end
