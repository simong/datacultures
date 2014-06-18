require 'rails_helper'

RSpec.describe "Points", :type => :request do
  describe "GET /points" do
    it "works! (now write some real specs)" do
      get points_path, format: :json
      expect(response.status).to be(200)
    end
  end
end
