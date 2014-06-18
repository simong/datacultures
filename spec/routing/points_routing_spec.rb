require "rails_helper"

RSpec.describe Api::V1::PointsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/v1/points").to route_to("api/v1/points#index")
    end

    it "routes to #show" do
      expect(:get => "/api/v1/points/1").to route_to("api/v1/points#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/v1/points").to route_to("api/v1/points#create")
    end

    it "routes to #update" do
      expect(:put => "/api/v1/points/1").to route_to("api/v1/points#update", :id => "1")
    end

  end
end
