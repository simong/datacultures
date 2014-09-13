module AppConfig

  class CourseConstants

    def self.course
      base_struct.api.course
    end

    def self.api_key
      base_struct.api.api_key
    end

    def self.base_url
      base_struct.api.server
    end

    private

    def self.base_struct
      EnvSettings.send(Rails.env)
    end

   end

end
