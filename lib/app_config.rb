module AppConfig

  require 'yaml'
  load 'lib/settings.rb'
  include Settings
  CONF_FILE = ['config/.env_conf.yml', 'config/.env_conf.yml.example']

  def self.load_app_settings
    if File.readable?(CONF_FILE.first)
      settings_location = CONF_FILE.first
    else
      settings_location = CONF_FILE.last
    end
    Kernel.const_set(:EnvSettings, Settings.deep_open_struct(YAML.load_file(settings_location)))
  end

  module CourseConstants

    def self.course
      base_struct.api.course
    end

    def self.api_key
      base_struct.api.api_key
    end

    def self.base_url
      base_struct.api.server
    end

    def self.lti_key
      base_struct.app.lti_key
    end

    def self.lti_secret
      base_struct.app.lti_secret
    end

    private

    ## ENV['RAILS_ENV'] works in Thor, not in the server
    ## ::Rails.env works in the server, not in Thor
    def self.rails_env
      ENV['RAILS_ENV'] || ::Rails.env
    end

    def self.base_struct
      EnvSettings.send(self.rails_env)
    end

   end

end
