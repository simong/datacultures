class ActivitiesController < ApplicationController

  require 'csv'

  QUERY_SQL = <<-END_OF_QUERY_SQL
    SELECT
       act.reason AS "action", s.name AS "student name",
       sum(act.delta) over(partition by s.canvas_user_id order by act.updated_at) as "student total score",
       act.delta AS "action score", to_char(act.updated_at, 'YYYY-MM-DD HH24:MI:SS') AS "action at"
    FROM activities act
    INNER JOIN students s ON act.canvas_user_id = s.canvas_user_id
    WHERE (act.score = 't') AND (act.expired = 'f') AND (act.assigned_discussion = 'f')
    ORDER BY act.updated_at ASC;
  END_OF_QUERY_SQL


  def index
    # Get the activities from the DB
    activities = sql_query(query: QUERY_SQL)

    # Convert the UTC timestamp into a PST timestamp and dump each record into CSV
    activities_csv = activities.rows.map{ |act|
      act[4] = Time.parse(act[4] + ' UTC').in_time_zone('Pacific Time (US & Canada)');
      act.to_csv
    }

    # Create the CSV file (column heades and a set of activities)
    data = activities.columns.to_csv + activities_csv.join

    # Send the CSV file to the user
    send_data data, type: :csv, disposition: 'attachement', filename: 'student_activities-' + Time.now.strftime("%Y_%m_%d-%I_%M_%S%P") + '.csv'
  end

  def sql_query(query:)
    ActiveRecord::Base.connection_pool.with_connection do |db_connection|
      db_connection.exec_query(query)
    end
  end


end
