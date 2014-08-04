class Canvas::ActivityStreamProcessor

  attr_accessor  :discussions_processor, :submissions_processor, :request_object

  def initialize(config)
    @request_object = config[:request_object] ||= Canvas::ApiRequest.new({base_url: config[:base_url], api_key: config[:api_key]})
    @discussions_processor = config[:discussions_processor] ||= Canvas::DiscussionsProcessor.new({request_object: @request_object})
    @submissions_processor = config[:submissions_processor] ||= Canvas::SubmissionsProcessor.new({request_object: @request_object})
  end


  def get_stream!(course)
    strm = @request_object.request.get('api/v1/courses/'+course+'/activity_stream')
    strm.body if strm
  end

  def call(stream)
    stream.each do |activity|
      case activity['type']
        when 'DiscussionTopic'
          discussions_processor.call(activity)
        when 'Submission'
          submissions_processor.call(activity)
        else
          # no op; add other behaviors here or in another 'when' clause above
      end
    end

  end

end
