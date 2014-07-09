require 'rails_helper'

RSpec.describe "Api::V1::Activities", :type => :request do
  describe "GET /activities" do
    it "works! (now write some real specs)" do
      get api_v1_activities_path, format: :json
      expect(response.status).to be(200)
    end
  end
end
