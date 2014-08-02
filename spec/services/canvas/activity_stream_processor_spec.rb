require 'rails_helper'

RSpec.describe Canvas::ActivityStreamProcessor, :type => :model do

  before(:all) do
    PointsConfiguration.delete_all
    PointsConfiguration.create({interaction: 'DiscussionTopic', points_associated: 12, active: true, pcid: 'Foo' })
    PointsConfiguration.create({interaction: 'DiscussionReply',   points_associated:  5, active: true, pcid: 'Bar'})
  end

  context 'object creation' do

    it 'creates an object fine' do
      expect(Canvas::ActivityStreamProcessor.new(stream: [{}], base_url: 'http://localhost:3100',
                                                 api_key: 'Foo Bar')).to be_an_instance_of Canvas::ActivityStreamProcessor
    end

  end

  let(:request_object) do
    config_data = {api_key:  Rails.application.secrets['requests']['api_keys']['teacher'],
                   base_url: Rails.application.secrets['requests']['base_url']}
    Canvas::ApiRequest.new(config_data)
  end

  let(:stream_with_discussion) do
    YAML.load_file('spec/fixtures/activity_streams/discussion_stream_no_entries.yml')
  end

  let(:stream_with_submission) do
    YAML.load_file('spec/fixtures/activity_streams/submission_stream.yml')
  end

  let(:stream_with_both) do
    YAML.load_file('spec/fixtures/activity_streams/mixed_stream.yml')
  end

  let(:empty_stream) do
    [{}]
  end

  let!(:discussions_processor) do
    Canvas::DiscussionsProcessor.new({request_object: request_object})
  end

  let!(:submissions_processor) do
    Canvas::SubmissionsProcessor.new({request_object: request_object})
  end

  context '#call' do

    it 'iterates on the stream, calling DiscussionsProcessor' do
      activity_stream_processor = Canvas::ActivityStreamProcessor.new({request_object: request_object,
                                      discussions_processor: discussions_processor,
                                      submissions_processor: submissions_processor})

      expect(discussions_processor).to receive(:call).once
      expect(submissions_processor).not_to receive(:call)
      activity_stream_processor.call(stream_with_discussion)
    end

    it 'iterates on the stream, calling SubmissionsProcessor' do
      activity_stream_processor = Canvas::ActivityStreamProcessor.new({request_object: request_object,
                                       discussions_processor: discussions_processor,
                                       submissions_processor: submissions_processor})
      expect(submissions_processor).to receive(:call).once
      expect(discussions_processor).not_to receive(:call)
      activity_stream_processor.call(stream_with_submission)
    end

    it 'iterates over the stream, calling processing methods' do
      activity_stream_processor = Canvas::ActivityStreamProcessor.new({request_object: request_object,
                                       discussions_processor: discussions_processor,
                                       submissions_processor: submissions_processor})
      expect(discussions_processor).to receive(:call).once
      expect(submissions_processor).to receive(:call).once
      activity_stream_processor.call(stream_with_both)
    end

    it 'iterates on the stream, does not call processor if no such items are present' do
      activity_stream_processor = Canvas::ActivityStreamProcessor.new({request_object: request_object,
                                       discussions_processor: discussions_processor,
                                       submissions_processor: submissions_processor})
      expect(discussions_processor).not_to receive(:call)
      expect(submissions_processor).not_to receive(:call)
      activity_stream_processor.call(empty_stream)
    end

  end

  context '#get_stream(course)' do

    it "calls the Canvas API for the raw stream JSON" do
      activity_stream_processor = Canvas::ActivityStreamProcessor.new({request_object: request_object,
                                       discussions_processor: discussions_processor,
                                       submissions_processor: submissions_processor})
      expect(request_object.request).to receive(:get).with("api/v1/courses/1/activity_stream")
      activity_stream_processor.get_stream!('1')
    end

  end

end
