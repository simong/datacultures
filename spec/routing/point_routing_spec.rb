require 'rails_helper'

RSpec.describe PointsController do

  describe "routing" do
    it {
      expect(:get => "/points/315.json").to route_to(
       :action => "show", :controller => "points",
       :id => "315", :format => "json" )
    }
  end


end