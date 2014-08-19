require 'rails_helper'

RSpec.describe Canvas::AssignmentsProcessor, :type => :model do

  let(:processor) do
    Canvas::AssignmentsProcessor.new({
        request_object: "",
        course: '1',
        submissions_processor: ''})
  end

  let(:assignment_json) do
    [{'id' => 3, 'has_submitted_submissions' => true},{'id' => 9}]
  end

  context '#call' do

    context 'calls the PagedApiProcessor to process submissions' do

      it "creates (if not passed in) the PagedApiProcessor" do
        allow_any_instance_of(Canvas::PagedApiProcessor).to receive(:call).and_return([])
        expect(Canvas::PagedApiProcessor).to receive(:new).and_call_original
        processor.call(assignment_json)
      end

      it "calls the PagedApiProcessor for each assignment with submissions" do
        expect_any_instance_of(Canvas::PagedApiProcessor).to receive(:call).once
        processor.call(assignment_json)
      end

    end

  end

 end
