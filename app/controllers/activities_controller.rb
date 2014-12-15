class ActivitiesController < ApplicationController

  require 'csv'

  QUERY_SQL = <<-END_OF_QUERY_SQL
    SELECT
       act.reason AS "action", s.name AS "student name",
       (SELECT SUM(delta) FROM activities a2 WHERE ((a2.expired = 'f') AND (a2.assigned_discussion = 'f') AND (a2.score = 't')
          AND (a2.canvas_user_id=act.canvas_user_id))) AS "student total score",
       act.delta AS "action score", to_char(act.updated_at, 'YYYY-MM-DD HH24:MI:SS') AS "action at"
    FROM activities act INNER JOIN students s ON act.canvas_user_id = s.canvas_user_id
      WHERE (act.score = 't') AND (act.expired = 'f') AND (act.assigned_discussion = 'f')
      AND (act.reason IN ('Submission', 'Like', 'Dislike', 'DiscussionTopic', 'DiscussionEdit', 'DiscussionReply', 'Comment'));
  END_OF_QUERY_SQL


  def index
    activities = sql_query(query: QUERY_SQL)
    send_data activities.columns.to_csv + activities.rows.map{|act| act.to_csv}.join,
              type: :csv, disposition: 'attachement', filename: 'student_activities-' + Time.now.strftime("%Y_%m_%d-%I_%M_%S%P")
  end

  def sql_query(query:)
    ActiveRecord::Base.connection_pool.with_connection do |db_connection|
      db_connection.exec_query(query)
    end
  end


end
