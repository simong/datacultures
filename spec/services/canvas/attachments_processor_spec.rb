require 'rspec'

RSpec.describe Canvas::AttachmentsProcessor, type: :model do

  before(:each) do
    Attachment.delete_all
  end

  let(:attachment_json) do
    JSON.parse(File.read('spec/fixtures/attachments/attachments.json'))
  end

  let(:processor) do
    p = Canvas::AttachmentsProcessor.new
    p.attachment_conf = {canvas_user_id: 4, assignment_id: 7, submission_id: 2, author: 'Picasso'}
    p
  end

  context 'is passed valid JSON for attachment(s)'  do

    it 'creates the attachment records' do
      expect{processor.call(attachment_json)}.to change{Attachment.count}.by(2)
    end

    it "doesn't add more records when some have been processed already" do
      processor.call([attachment_json.first])
      expect{processor.call(attachment_json)}.to change{Attachment.count}.by(1)
    end

    # equivalent to resubmitting with no attachment. Is this possible in Canvas?
    it "erases the old records, even if there are no new records." do
      processor.call(attachment_json)
      expect{processor.call([])}.to change{Attachment.count}.by(-2)
    end

  end

end

