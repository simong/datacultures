require 'rails_helper'

RSpec.describe Canvas::EngagementIndexScoringProcessor, :type => :model do

  before(:all) do
    PointsConfiguration.delete_all
    PointsConfiguration.create({interaction: 'DiscussionTopic', points_associated: 12, active: true, pcid: 'Foo' })
    PointsConfiguration.create({interaction: 'DiscussionReply',   points_associated:  5, active: true, pcid: 'Bar'})
  end

  context 'object creation' do

    it 'creates an object fine' do
      expect(Canvas::EngagementIndexScoringProcessor.new({base_url: 'http://localhost:3100',
                                                 api_key: 'Foo Bar', course: 1})).to \
            be_an_instance_of Canvas::EngagementIndexScoringProcessor
    end

  end

  let(:request_object) do
    config_data = {api_key:  Rails.application.secrets['requests']['api_keys']['teacher'],
                   base_url: Rails.application.secrets['requests']['base_url']}
    Canvas::ApiRequest.new(config_data)
  end

  let(:processing_config) do
    {discussions_processor: :discussions_processor, assignments_processor: :assignments_processor, request_object: 1, course: '1'}
  end

  let(:engagement_index_scoring_processor) do
    Canvas::EngagementIndexScoringProcessor.new(processing_config)
  end

  context '#call' do

    it 'calls Canvas::PagedApiProcessor twice' do
      # stub call on PagedApiProcessor
      allow_any_instance_of(Canvas::PagedApiProcessor).to receive(:call).and_return([])
      expect(Canvas::PagedApiProcessor).to receive(:new).twice.and_call_original
      engagement_index_scoring_processor.call
    end

  end

end
