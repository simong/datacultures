require 'rspec'

RSpec.describe Canvas::AttachmentsProcessor, type: :model do

  before(:each) do
    Attachment.delete_all
  end

  let(:submission) do
    JSON.parse(File.read('spec/fixtures/submissions/submission_stream.json')).first
  end

  let(:attachment_json) do
    JSON.parse(File.read('spec/fixtures/attachments/attachments.json'))
  end

  let(:processor) do
    Canvas::AttachmentsProcessor.new({}, 1)
  end

  context 'is passed valid JSON for attachment(s)'  do

    it 'creates the attachment records' do
      expect{processor.call(submission, attachment_json)}.to change{Attachment.count}.by(2)
    end

    it "doesn't add more records when some have been processed already" do
      processor.call(submission, [attachment_json.first])
      expect{processor.call(submission, attachment_json)}.to change{Attachment.count}.by(1)
    end

    # equivalent to resubmitting with no attachment. Is this possible in Canvas?
    it "erases the old records, even if there are no new records." do
      processor.call(submission, attachment_json)
      expect{processor.call(submission, [])}.to change{Attachment.count}.by(-2)
    end

  end

end

