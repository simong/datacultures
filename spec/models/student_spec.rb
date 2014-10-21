require 'rails_helper'
require 'spec_helper'

RSpec.describe Student, :type => :model do

  let(:student_data) do
    { 'primary_email' => 'fox@vulpes.net', 'name' => 'Reynard Fox',
      'sortable_name' => 'Fox, Reynard' }
  end

  # let(:fox) do
  #   student_data.
  # end

  let(:params) do
    {'lis_person_name_family' => 'Fox', 'lis_person_name_given' => 'Reynard', 'custom_canvas_user_id' => '4',
     'lis_person_name_full' => 'Reynard Fox', 'lis_person_contact_email_primary' => 'fox@vulpes.net' }
  end

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

  context 'Instance Methods' do

    describe '#update_if_needed' do

      let(:student) { FactoryGirl.create(:student, student_data)}

      it "does not touch the record if no values have changed" do
        student = FactoryGirl.create(:student, student_data)
        expect(student.update_if_needed(student_data)).to be_nil
      end

      it "updates the record if something has changed" do
        student = FactoryGirl.create(:student, name: 'Reynard')
        new_student_data = student_data
        new_student_data['primary_email']  = 'bazing@baring.fooing'
        expect(student.update_if_needed(new_student_data)).to eq(true)
      end

    end

  end

  context "Class methods" do

    describe '::create_by_canvas_user_id' do

      it 'does nothing if the student exists' do
        student_data_with_canvas_id = student_data.merge({canvas_user_id: 17})
        FactoryGirl.create(:student, student_data_with_canvas_id)
        expect{Student.create_by_canvas_user_id(17)}.to_not change{Student.count}
      end

      it 'creates the student record if it does not exist' do
        student_data_with_canvas_id = student_data.merge({canvas_user_id: 17})
        stub_request(:get, AppConfig::CourseConstants.base_url + 'api/v1/users/17/profile').
            to_return({body: {'name' => 'FooBar', 'sortable_name' => 'Bar, Foo',
                              'primary_email' => 'bar@foo.baz'}})
        expect{Student.create_by_canvas_user_id(17)}.to change{Student.count}.by(1)
      end

    end


    describe '::ensure_student_record_exists_by_canvas_id' do

      it 'creates the student record if it does not exist' do
        expect{Student.ensure_student_record_exists(params)}.to change{Student.count}.by(1)
      end

      it 'does not create new record if the student already exists' do
        FactoryGirl.create(:student, {canvas_user_id: params['custom_canvas_user_id']})
        expect{Student.ensure_student_record_exists(params)}.to_not change{Student.count}
      end

      it 'updates the record if the data has changed' do
        FactoryGirl.create(:student, {canvas_user_id: params['custom_canvas_user_id'], name: 'Reynard Fox'})
        expect{Student.ensure_student_record_exists(params)}.to_not change{Student.find_by_canvas_user_id(4).name}
      end

    end

  end

end


