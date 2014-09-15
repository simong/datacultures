module Models
  module MockHelpers
    def setup_request
      if mock?
        yield
      else
        WebMock.allow_net_connect!
      end
    end

    private

    def mock?
      case ENV['MOCK']
        when 'always'
          true
        when 'never'
          false
        else
          !EnvSettings.send(Rails.env).real_requests  # don't encode '.test' in very rare case it isn't 'test'
      end
    end

  end
end
