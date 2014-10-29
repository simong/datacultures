require 'rails_helper'

RSpec.describe Canvas::SubmissionsProcessor, :type => :model do

  before(:all) do
    PointsConfiguration.delete_all
    PointsConfiguration.create({interaction: 'Submission', points_associated: 30, active: true, pcid: 'Foo' })
  end

  let(:submission_stream) do
    JSON.parse(File.read('spec/fixtures/submissions/submission_stream.json'))
  end

  # request configuration data (for rare actual call testing)
  let(:base_url)   {  AppConfig::CourseConstants.base_url                                          }
  let(:api_key)    {  AppConfig::CourseConstants.api_key                                           }
  let(:course)     {  AppConfig::CourseConstants.course                                            }

  let(:request_object) {  ApiRequest.new(base_url: base_url, api_key: api_key)           }

  let(:processor) do
    Canvas::SubmissionsProcessor.new({request_object: request_object})
  end

  before(:all) do
    FactoryGirl.create(:student, {canvas_user_id: 9})
  end

  after(:all) do
    Student.delete_all
  end

  context '#call' do

    context 'without valid parameters'  do

      it "does not register an Activity without a valid user_id" do
        submission_stream.first['user_id'] = nil
        expect{processor.call(submission_stream)}.to_not change{Activity.count}
      end
    end

    context  'with valid parameters' do
      it 'creates an Activity to track scoring if it has not been done so before'  do
        expect{processor.call(submission_stream)}.to change{Activity.count}.by(1)
      end

      it 'does not create an Activity for a submission if it has already been done.' do
        Activity.create({reason: 'Submission', delta: 7, canvas_user_id: 9, scoring_item_id: 3 })
        expect{processor.call(submission_stream)}.to_not change{Activity.count}
      end
    end

  end

 end

