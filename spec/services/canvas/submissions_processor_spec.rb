require 'rails_helper'

RSpec.describe Canvas::ActivityStreamProcessor, :type => :model do

  before(:all) do
    PointsConfiguration.delete_all
    PointsConfiguration.create({interaction: 'Submission', points_associated: 30, active: true, pcid: 'Foo' })
  end

  let(:submission_stream) do
    JSON.parse(File.read('spec/fixtures/submissions/submission_stream.json'))
  end

  let(:processor) do
    Canvas::SubmissionsProcessor.new({})
  end

  context '#call' do

    context 'without valid parameters'  do

      it "witout a valid associated assignment" do
        stream = submission_stream.reject{|k,v| k=="assignment"}
        expect{processor.call(stream)}.to_not change{Activity.count}
      end

      it "without a valid user id" do
        stream = submission_stream.reject{|k,v| k=="user_id"}
        expect{processor.call(stream)}.to_not change{Activity.count}
      end
    end

    context  'with valid parameters' do
      it 'and has not been credited yet'  do
        expect{processor.call(submission_stream)}.to change{Activity.count}.by(1)
      end

      it 'and has been already credited' do
        Activity.create({reason: 'Submission', delta: 7, canvas_user_id: 9, canvas_scoring_item_id: 3 })
        expect{processor.call(submission_stream)}.to_not change{Activity.count}
      end
    end

  end

 end

