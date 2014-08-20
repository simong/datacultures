require 'rails_helper'

RSpec.describe Activity, :type => :model do

  before(:all) do
    Activity.delete_all
    FactoryGirl.create_list(:activity, 5)
  end

  describe "Activity" do
    it "should belong to a student" do
      a = Activity.reflect_on_association(:student)
      expect(a.macro).to eq(:belongs_to)
    end

    it "does not update until called to do so." do
      Activity.update_scores!
      expect{FactoryGirl.create_list(:activity, 5)}.to_not change{Activity.student_scores}
    end

    it "updates scores when called to do so" do
      Activity.update_scores!
      FactoryGirl.create(:activity)
      expect{Activity.update_scores!}.to change{Activity.student_scores}
    end

    it "Activity.student_scores returns a hash" do
      expect(Activity.student_scores).to be_kind_of Hash
    end

  end
end
