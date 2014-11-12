require 'rails_helper'

RSpec.describe Activity, :type => :model do

  before(:all) do
    Activity.delete_all
    FactoryGirl.create(:activity)
  end

  describe "Activity" do
    it "should belong to a student" do
      a = Activity.reflect_on_association(:student)
      expect(a.macro).to eq(:belongs_to)
    end

    it "Activity.student_scores returns a hash" do
      expect(Activity.student_scores).to be_kind_of Hash
    end

    it "increases the score of the person taking the action." do
      FactoryGirl.create(:activity, {score: true, delta: 1, canvas_user_id: 13})  # change BY can't handle *from* nil
      expect{FactoryGirl.create(:activity, {canvas_user_id: 13, score: true, delta: 5 })}.
          to change{Activity.student_scores[13]}.by(5)
    end

  end
end
