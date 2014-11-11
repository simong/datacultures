class ActivitiesController < ApplicationController

  def index
    # data is '#pluck'ed as that only instantiates a Ruby array of strings and dates,
    #   and not a whole AR::Relation filled with Activity records.
    activities = Activity.pluck('reason, canvas_user_id, delta, expired, updated_at')
    send_data DecoratedCSV.generate(ActivityDecorator, activities),
              type: :csv, disposition: 'attachement', filename: 'student_activities-' + Time.now.strftime("%Y_%m_%d-%I_%M_%S%P")
  end

end
