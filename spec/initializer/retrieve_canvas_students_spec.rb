ENV["initializer_test"] = "true"
require 'rails_helper'

RetrieveCanvasStudents = Struct.new(:description)

RSpec.describe RetrieveCanvasStudents do

  let(:url){
    course_id = Rails.application.secrets['requests']['course']
    "http://localhost:3100/api/v1/courses/#{course_id}/search_users"
  }

  let(:valid_student_attributes){
    [{
        "id" => 1,
        "name" => "Nolan Chan",
        "sortable_name" => "Chan, Nolan",
        "sis_user_id" => "1234",
        "primary_email" => "nolanchan@berkeley.edu",
        "section" => "A",
        "share" => false
    }]
  }

  it "should not blow up when the returned status is not 200" do
    stub_request(:get, url).to_return(:status => 400, :body => "RANDOM INFO", :headers => {})
    retrieve_canvas_students()
    expect(Student.all).to be_empty
  end

  it "should populate users when it receives valid data" do
    stub_request(:get, url).to_return(:status => 200, :body => valid_student_attributes, :headers => {})
    retrieve_canvas_students()
    expect(Student.all.count).to eq(1)
  end

end
