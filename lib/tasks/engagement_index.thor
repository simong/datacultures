class EngagementIndex < Thor

  require 'thor/rails'
  include Thor::Rails

  desc "print", "Print Rails env"

  def print_env
    puts ENV['RAILS_ENV']
  end

  desc "update", "Update the engagement index"

  def update
    conf   = YAML.load_file('config/secrets.yml')[ENV['RAILS_ENV']]['requests'  ]
    course = conf['course']
    key    = conf['api_keys']['teacher']
    base   = conf['base_url']
    activity_stream = Canvas::ActivityStreamProcessor.new({api_key: key, base_url: base})
    stream = activity_stream.get_stream!(course)
    activity_stream.call(stream)
  end

end
