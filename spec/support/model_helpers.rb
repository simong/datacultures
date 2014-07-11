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
      # 'always', 'never', or 'rails_env', defaults to true if none defined
      byebug
      case ENV['MOCK']
        when 'always'
          true
        when 'never'
          false
        when 'rails_env'   # same as ENV['MOCK'] undefined
          !Rails.application.secrets['requests']['real']
        else
          !Rails.application.secrets['requests']['real']
      end
    end

  end
end

# in config/secrets.yml add the 'real: true' line, and 
# test:
#     secret_key_base: 80a0dd05520dd37c2da8fb8df9ad431a2a518ee21c1c6e8e64244e37d47640ef4a01a389722aecf23c0c1d4221717c1d07a868adbfd930bd598eefebefe9d403
# course_id: '1'
# requests:
#     real: true