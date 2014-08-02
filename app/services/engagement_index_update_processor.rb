class EngagementIndexUpdateProcessor

  def self.call(conf)
    key    = conf['api_keys']['teacher']
    base   = conf['base_url']
    course = conf['course']
    activity_stream = Canvas::ActivityStreamProcessor.new({api_key: key, base_url: base})
    stream = activity_stream.get_stream!(course)
    activity_stream.call(stream)
  end

end
