require 'clockwork'
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

module Clockwork

  every(10.seconds, 'process_discussions'){
    DiscussionUpdateWorker.perform_async(AppConfig::CourseConstants.base_url,
                                         AppConfig::CourseConstants.course)
  }
  every(10.seconds, 'process_assignments'){
    AssignmentUpdateWorker.perform_async(AppConfig::CourseConstants.base_url,
                                         AppConfig::CourseConstants.course)
  }

end
