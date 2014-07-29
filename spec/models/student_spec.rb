require 'rails_helper'
require 'spec_helper'

RSpec.describe Student, :type => :model do

  describe "Student" do
    it "has a valid factory" do
      expect(FactoryGirl.build(:student)).to be_valid
    end

    it "should have many activities" do
      s = Student.reflect_on_association(:activities)
      expect(s.macro).to eq(:has_many)
    end

    it "has a sortable name" do
      s = FactoryGirl.build(:student, name: "Kernel Sanders")
      expect(s.sortable_name).to eq("Sanders, Kernel")
    end

  end
end


