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

    describe '#visible_to' do

      before(:all) do
        Student.delete_all
        @sharing_students    = FactoryGirl.create_list(:student, 2, share: true)
        @nonsharing_students = FactoryGirl.create_list(:student, 2, share: false)
        @teacher             = FactoryGirl.create(:student)
      end

      after(:all) do
        Student.delete_all
        Activity.delete_all
      end

      it "shows everything to an 'all_seeing' user"  do
        expect {
          FactoryGirl.create(:activity, canvas_user_id: @sharing_students.first.canvas_user_id)
          FactoryGirl.create(:activity, canvas_user_id: @nonsharing_students.first.canvas_user_id)
        }.to change{Activity.visible_to(user_id: @teacher.canvas_user_id, all_seeing: true).count}.by(2)
      end

      it "shows only their own activity to a non-sharer" do
        expect {
          FactoryGirl.create(:activity, canvas_user_id: @nonsharing_students.last.canvas_user_id)
          FactoryGirl.create(:activity, canvas_user_id: @nonsharing_students.first.canvas_user_id)
          FactoryGirl.create(:activity, canvas_user_id: @sharing_students.first.canvas_user_id)
        }.to change{Activity.visible_to(user_id: @nonsharing_students.first.canvas_user_id,
                                        all_seeing: false).map(&:canvas_user_id)}.to([@nonsharing_students.first.canvas_user_id])
      end

      it "shows all sharing activites to all sharing students" do
        expect {
          FactoryGirl.create(:activity, canvas_user_id: @sharing_students.first.canvas_user_id)
          FactoryGirl.create(:activity, canvas_user_id: @sharing_students.last.canvas_user_id)
          FactoryGirl.create(:activity, canvas_user_id: @nonsharing_students.first.canvas_user_id)
        }.to change{Activity.visible_to(user_id: @sharing_students.first.canvas_user_id,
                 all_seeing: false).map(&:canvas_user_id).sort}.
                 to(@sharing_students.map(&:canvas_user_id).sort)
      end

    end

  end
end
