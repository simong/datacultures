class ApiRequest

  attr_reader    :base_url, :api_key
  attr_accessor  :request

  def initialize(api_key:, base_url:)
    @api_key = api_key
    @base_url = base_url
    @request = request_object
  end

  ## attr_accessor not possible here, cached request_object must be remade
  def base_url= new_base_url
    @base_url = new_base_url
    @request = request_object
  end

  def api_key= new_api_key
    @api_key = new_api_key
    @request = request_object
  end

  private

  def request_object
    f = Faraday.new(url: @base_url)
    f.headers['User-Agent'] = I18n.t "app_name"
    f.headers.merge!({'Authorization' => "Bearer #{api_key}"})
    f.builder.swap(1, Faraday::Adapter::NetHttpPersistent)
    f.response :json, :content_type => 'application/json'
    f
  end

end
