require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe Api::V1::ActivitiesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Activity. As you add validations to Activity, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {canvas_user_id: "FOO", reason: "liked", delta: 1, canvas_scoring_item_id: 'bar'}
  }

  let(:invalid_attributes) {
    {canvas_user_id: "BAR", reason: 3 }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ActivitiesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all activities as @activities" do
      expect(valid_attributes).to eq({:canvas_user_id=>"FOO", :reason=>"liked", :delta=>1, :canvas_scoring_item_id=>"bar"})
      activity = Activity.create! valid_attributes
      get :index, {format: :json}, valid_session
      expect(assigns(:activities)).to eq([activity])
    end
  end

  describe "GET show" do
    it "assigns the requested activity as @activity" do
      activity = Activity.create! valid_attributes
      get :show, {id:  activity.to_param, format:  :json}, valid_session
      expect(assigns(:activity)).to eq(activity)
    end

    it "returns not found for a non-existent activity" do
      get :show, {id: "DOES NOT EXIST", format: :json}, valid_session
      expect(response.status).to eq(204)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Activity" do
        expect {
          post :create, {activity:  valid_attributes, format: :json}, valid_session
        }.to change(Activity, :count).by(1)
      end

      it "assigns a newly created activity as @activity" do
        post :create, {activity: valid_attributes, format: :json}, valid_session
        expect(assigns(:activity)).to be_a(Activity)
        expect(assigns(:activity)).to be_persisted
      end

      it "renders the created activity" do
        post :create, {activity: valid_attributes, format: :json}, valid_session
        expect(response.body).to eq(Activity.last.to_json)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved activity as @activity" do
        post :create, {activity: invalid_attributes, format: :json}, valid_session
        expect(assigns(:activity)).to be_a_new(Activity)
      end
    end
  end

  describe "PUT update (logical delete)" do
    describe "with valid params" do

      it "updates the requested activity" do
        activity = Activity.create! valid_attributes
        put :update, {id: activity.to_param}, valid_session
        activity.reload
        expect(activity.deleted_at).to_not be_nil
      end

      it "returns no content after deleting a activity" do
        activity = Activity.create! valid_attributes
        put :update, {id: activity.to_param }, valid_session
        expect(response.status).to eq(204)
      end

    end

    describe "with invalid params" do

      it "returns 'no content' if the activity does not exist " do
        put :update, {id: "NONEXISTENT"}, valid_session
        expect(response.status).to eq(422)
      end

    end
  end

end
