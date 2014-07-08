require 'rails_helper'

RSpec.describe Canvas::ApiRequest, :type => :model do

  context "ApiRequest Object creation" do
    let (:api_params) do
      { base_url:  'http://localhost/', api_key: 'some token'}
    end

    it "should not raise an exception if required params are present" do
     expect{Canvas::ApiRequest.new(api_params)}.not_to raise_error
    end

    it "raises an ArgumentError if not passed in the correct parameters" do
      expect{Canvas::ApiRequest.new({foo:  'bar'})}.to raise_error(ArgumentError)
    end

    it "creates a valid object if the right params are passed in" do
      @connection = Canvas::ApiRequest.new(api_params)
      expect(@connection).to be_kind_of Canvas::ApiRequest
    end
  end

  context "Actual API Requests" do

    WebMock.allow_net_connect!

    let (:request_object) do
      Canvas::ApiRequest.new({base_url: Rails.application.secrets.requests['base_url'], api_key: 'unset key'})
    end

    it "returns not found (404) for invalid path but valid API key" do
      request_object.api_key =  Rails.application.secrets.requests['api_keys']['discussions_api']
      resp = request_object.request.get('/foo/bar')
      expect(resp.status).to be(404)
    end

    it "returns 401 on an invalid api key" do
      resp = request_object.request.get('/api/v1/courses/1/discussion_topics')
      expect(resp.status).to be(401)
    end

    it "returns successfully with a valid api token" do
      request_object.api_key = Rails.application.secrets.requests['api_keys']['discussions_api']
      resp = request_object.request.get('/api/v1/courses/1/discussion_topics.json')
      expect(resp.status).to be(200)
    end

  end

end
