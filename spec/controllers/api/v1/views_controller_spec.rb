require 'rails_helper'

HTTP_SYMBOLS = {conflict: 409, created: 201, gone: 410, no_content: 204, ok: 200}

RSpec::Matchers.define :have_return_status do |expected|
  match do |actual|
    actual == HTTP_SYMBOLS[expected]
  end
end

RSpec.describe Api::V1::ViewsController, :type => :controller do

  let(:post_params) { { gallery_id: 'picture-2-300' } }
  let(:valid_session) { {} }

  describe "POST increment" do

    context "When a view exists" do

      it "indicates that a resource was created" do
        post :increment, post_params, valid_session
        expect(response.status).to have_return_status :ok
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
