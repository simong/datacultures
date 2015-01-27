module CanvasRelativeUrlHelper

  COURSE_ROOT_PATH = '/api/v1/courses/'
  USERS_ROOT_PATH  = '/api/v1/users/'
  PAGINATION_SUFFIX = '?per_page=250'

  require 'string_refinement'
  using StringRefinement

  PATH_FINAL = {
    discussion_topics: '/discussion_topics',
    assignments: '/assignments',
    submissions: '/submissions',
    entries:  '/entries',
    files: '/files'
  }

  def course_api_url(course:, final_url:, mid_variable: '', mid_const: nil)
    COURSE_ROOT_PATH + course.to_s + mid_variable.slash_bracket(PATH_FINAL[mid_const]) + PATH_FINAL[final_url] + PAGINATION_SUFFIX
  end

  def course_files_url(course:)
    COURSE_ROOT_PATH + course.to_s + PATH_FINAL[:files]
  end


end
