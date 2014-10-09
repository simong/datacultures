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

  context "Class methods" do

    describe '::ensure_student_record_exists_by_canvas_id' do

      CANVAS_STUDENT_PROFILE_DATA = { 'primary_email' => 'fox@vulpes.net', 'name' => 'Reynard the Fox',
                                      'sortable_name' => 'Fox, Reynard the' }
      it 'creates the student record if it does not exist' do
        stub_request(:get,AppConfig::CourseConstants.base_url + 'api/v1/users/4/profile').
          to_return({status: 200, body: CANVAS_STUDENT_PROFILE_DATA })
        expect{Student.ensure_student_record_exists_by_canvas_id(4)}.to change{Student.count}.by(1)
      end

      it 'does not create new record if the student already exists' do
        stub_request(:get,AppConfig::CourseConstants.base_url + 'api/v1/users/4/profile').
            to_return({status: 200, body: CANVAS_STUDENT_PROFILE_DATA })
        FactoryGirl.create(:student, canvas_user_id: 4)
        expect{Student.ensure_student_record_exists_by_canvas_id(4)}.to_not change{Student.count}
      end

    end

  end
end


