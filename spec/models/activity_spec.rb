require 'rails_helper'

RSpec.describe Activity, :type => :model do

  describe "Activity" do
    it "should belong to a student" do
      a = Activity.reflect_on_association(:student)
      expect(a.macro).to eq(:belongs_to)
    end
  end
end
