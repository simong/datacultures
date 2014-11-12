require 'draper'

class ActivityDecorator < Draper::Decorator

  decorate :activity

  CSV_HEADER_ROW =  I18n.t 'csv_column_heads'
  ACTIVITY_SHORT_NAMES = (I18n.t 'short_activity_names').stringify_keys

  def as_csv_row
    student_names = Student.get_students_by_canvas_id   # don't use source.student.name, results in n+1 queries
    student_scores = Activity.student_scores
    [
        ACTIVITY_SHORT_NAMES[source[0]],
        student_names[source[1]],
        student_scores[source[1]],
        source[2],
        !source[3],
        source[4]
    ]
  end

end
