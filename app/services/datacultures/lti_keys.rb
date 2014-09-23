class Datacultures::LtiKeys

  CONF_PATH = 'config/.env_conf.yml'

  require 'securerandom'
  require 'yaml'

  def self.current
    YAML.load_file(CONF_PATH)
  end

  def self.new_lti_keys
    {'lti_secret' => SecureRandom.base64(70), 'lti_key' => SecureRandom.base64(70)}
  end

  def self.rails_env
    ENV['RAILS_ENV'] || Rails.env
  end

  def self.show_keys
    current[rails_env]
  end

  def self.update_lti_keys
    base = current
    base[rails_env]['app'] = new_lti_keys
    f = File.open(CONF_PATH, 'w')
    f.print base.to_yaml
    f.close
  end

end
