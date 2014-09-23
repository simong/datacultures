class Keys < Thor

  require 'thor/rails'
  include Thor::Rails

  desc "list", "List App Secret and App Key"
  def list
    puts 'LTI key:    ' + AppConfig::CourseConstants.lti_key
    puts 'LTI secret: ' + AppConfig::CourseConstants.lti_secret
    puts 'API key:    ' + AppConfig::CourseConstants.api_key
  end

  desc "lti_new", "Generate LTI key and secret"
  def lti_new
    Datacultures::LtiKeys.update_lti_keys
    AppConfig.load_app_settings
  end

end
