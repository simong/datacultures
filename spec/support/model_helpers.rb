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
          !Rails.application.secrets['requests']['real']
      end
    end

  end
end
