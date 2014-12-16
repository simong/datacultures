require 'rspec'

RSpec.describe Canvas::GenericUrlProcessor, type: :model do

  before(:all) do
    FactoryGirl.create(:points_configuration, {interaction: 'Submission', active: true, points_associated: 21})
  end

  before(:each) do
    GenericUrl.delete_all
    Activity.delete_all
  end

  let(:generic_urls_json) do
    JSON.parse(File.read('spec/fixtures/generic_urls/generic_urls.json'))
  end

  let(:processor) do
    Canvas::GenericUrlProcessor.new
  end

  context 'is passed valid JSON for generic url(s)'  do

    it 'creates the generic_url records' do
      expect{processor.call(generic_urls_json)}.to change{GenericUrl.count}.by(1)
    end

    it "doesn't add a record when it has been processed already" do
      processor.call(generic_urls_json)
      expect{processor.call(generic_urls_json)}.to_not change{GenericUrl.count}
    end

    it "creates a new Activity record for the initial generic URL submission" do
      expect{processor.call(generic_urls_json)}.to change{GenericUrl.count}.by(1)
    end

  end

end

