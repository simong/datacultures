class EngagementIndex < Thor

  require 'thor/rails'
  include Thor::Rails

  desc "print", "Print Rails env"

  def print_env
    puts ENV['RAILS_ENV']
  end

  desc "update", "Update the engagement index"

  def update
    conf   = YAML.load_file('config/secrets.yml')[ENV['RAILS_ENV']]['requests']
    Canvas::EngagementIndexScoringProcessor.new(conf.symbolize_keys).call
  end

end
