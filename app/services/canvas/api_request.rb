class Canvas::ApiRequest

  include ActiveModel::Validations

  attr_reader    :base_url, :api_key
  attr_accessor  :request

  def initialize(config_data)
    raise ArgumentError unless config_data.is_a?(Hash) && config_data[:api_key] && config_data[:base_url]
    [:api_key, :base_url].each do |k|
      self.instance_variable_set('@'+k.to_s, config_data[k])
    end
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
    f = Faraday.new(url: base_url)
    f.headers['User-Agent'] = I18n.t "app_name"
    f.headers.merge!({'Authorization' => "Bearer #{api_key}"})
    f.builder.swap(1, Faraday::Adapter::NetHttpPersistent)
    f.response :json, :content_type => 'application/json'
    f
  end

end
