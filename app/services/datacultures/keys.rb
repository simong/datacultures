class Datacultures::Keys

  LTI_CONF_PATH = 'config/.env_conf.yml'
  RAILS_SECRETS_PATH = 'config/secrets.yml'

  require 'securerandom'
  require 'yaml'

  def self.lti_current
    YAML.load_file(LTI_CONF_PATH)
  end

  def self.app_current
    YAML.load_file(RAILS_SECRETS_PATH)
  end

  def self.new_lti_keys
    {'lti_secret' => SecureRandom.base64(70), 'lti_key' => SecureRandom.base64(70)}
  end

  def self.new_app_secret
    { 'secret_key_base' => SecureRandom.hex(70) }
  end

  def self.rails_env
    ENV['RAILS_ENV'] || Rails.env
  end

  def self.show_lti_keys
    lti_current[rails_env]
  end

  def self.update_lti_keys
    base = lti_current
    base[rails_env]['app'] = new_lti_keys
    f = File.open(LTI_CONF_PATH, 'w')
    f.print base.to_yaml
    f.close
  end

  def self.update_app_secret_key
    base = app_current
    base[rails_env].merge!(new_app_secret)
    f = File.open(RAILS_SECRETS_PATH, 'w')
    f.print base.to_yaml
    f.close
  end

end
