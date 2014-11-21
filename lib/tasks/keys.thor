class Keys < Thor

  require 'thor/rails'
  require 'yaml'
  require 'pp'
  include Thor::Rails

  desc "lti_list", "List LTI Shared Secret, Consumer Key and Canvas API Key"
  def lti_list
    puts 'LTI key:    ' + AppConfig::CourseConstants.lti_key
    puts 'LTI secret: ' + AppConfig::CourseConstants.lti_secret
    if AppConfig::CourseConstants.api_key.kind_of? String
      puts 'API key:    ' + AppConfig::CourseConstants.api_key
    else
      puts 'API key not present'
    end
  end

  desc "app_secrets_list", "List Application's Secret Key Base"
  def app_secrets_list
    secrets = YAML.load_file('config/secrets.yml')
    puts "App secrets by environment:"
    pp secrets
  end

  desc "app_new_secret", "Generate new Application Secret Key Base"
  def app_new_secret
    Datacultures::Keys.update_app_secret_key
  end

  desc "lti_new", "Generate LTI key and secret"
  def lti_new
    Datacultures::Keys.update_lti_keys
    AppConfig.load_app_settings
    lti_list
  end

end
