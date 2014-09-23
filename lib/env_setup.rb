module EnvSetup

  load 'lib/settings.rb'
  include Settings
  CONF_FILE = ['config/.env_conf.yml', 'config/.env_conf.yml.example']

  def load_app_settings
      if File.readable?(CONF_FILE.first)
        settings_location = CONF_FILE.first
      else
        settings_location = CONF_FILE.last
      end
      Kernel.const_set(:EnvSettings, deep_open_struct(YAML.load_file(settings_location)))
    end

end
