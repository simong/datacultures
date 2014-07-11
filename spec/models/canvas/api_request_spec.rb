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

    let (:request_object) do
      Canvas::ApiRequest.new({base_url: Rails.application.secrets['requests']['base_url'], api_key: 'unset key'})
    end

    it "returns not found (404) for invalid path but valid API key" do
      request_object.api_key =  Rails.application.secrets['requests']['api_keys']['teacher']
      setup_request {
        stub_request(:get, Rails.application.secrets['requests']['base_url'] + 'api/v1/foo/bar').to_return({status: 404})
      }
      resp = request_object.request.get('api/v1/foo/bar')
      expect(resp.status).to be(404)
    end

    it "returns 401 on an invalid api key (but valid path)" do
      path = "api/v1/courses/#{Rails.application.secrets['requests']['course']}/discussion_topics"
      protocol_and_host = Rails.application.secrets['requests']['base_url']
      setup_request {
        stub_request(:get, protocol_and_host + path ).to_return({status: 401})
      }
      resp = request_object.request.get(path)
      expect(resp.status).to be(401)
    end

    it "returns successfully with a valid api token" do
      request_object.api_key = Rails.application.secrets['requests']['api_keys']['teacher']
      path = "api/v1/courses/#{Rails.application.secrets['requests']['course']}/discussion_topics"
      protocol_and_host = Rails.application.secrets['requests']['base_url']
      setup_request {
        stub_request(:get, protocol_and_host + path ).to_return({status: 200})
      }
      resp = request_object.request.get(path)
      expect(resp.status).to be(200)
    end

  end

end
