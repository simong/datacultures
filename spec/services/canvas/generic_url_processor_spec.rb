require 'rspec'

RSpec.describe Canvas::GenericUrlProcessor, type: :model do

  let(:base_url)   {  AppConfig::CourseConstants.base_url   }
  let(:api_key)    {  AppConfig::CourseConstants.api_key    }
  let(:course)     {  AppConfig::CourseConstants.course     }

  before(:all) do
    FactoryGirl.create(:points_configuration, {interaction: 'Submission', active: true, points_associated: 21})
  end

  before(:each) do
    GenericUrl.delete_all
    Activity.delete_all
  end

  let(:submission) do
    JSON.parse(File.read('spec/fixtures/generic_urls/generic_urls.json'))
  end

  let(:processor) do
    api_request = ApiRequest.new(base_url: base_url, api_key: api_key)
    Canvas::GenericUrlProcessor.new(api_request, 1)
  end

  context 'is passed valid JSON for generic url(s)'  do

    it 'creates the generic_url records' do

    # Stub the downloaded file
    stub_request(:get, "https://localhost:3100/files/259732101/download?download_frd=1").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => File.new('spec/fixtures/images/public-domain.jpg'), :headers => {})

    # Stub the "request-to-upload" request
    stub_request(:post, "http://localhost:3100/api/v1/courses/1/files").
      to_return(:status => 200, :body => '{"upload_url": "http://localhost:3100/files", "upload_params": {}}', :headers => {'Content-Type' => 'application/json'})
    # Stub the actual upload
    stub_request(:post, "http://localhost:3100/files").
      to_return(:status => 302, :body => '', :headers => {'location' => 'http://localhost:3100/confirm'})
    # Stub the confirm request
    stub_request(:post, "http://localhost:3100/confirm").
      to_return(:status => 200, :body => '{"id": 1, "url": "http://localhost:3100/url/to/file"}', :headers => {'Content-Type' => 'application/json'})
    # Stub the hiding of the file
    stub_request(:put, "http://localhost:3100/api/v1/files/1").
      with(:body => {"hidden"=>"true"}).
      to_return(:status => 200, :body => '', :headers => {})

    # Run the Generic URL processor
    expect{processor.call(submission)}.to change{GenericUrl.count}.by(1)
    end

  end

end

