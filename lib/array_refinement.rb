module ArrayRefinement

  refine Array do

    def name_sortable
      family = self.last
      given = (size > 1) ? self.first : nil
      mid = (!(family.nil? || family.to_s.empty?) && !(given.nil? || given.to_s.empty?)) ? ', ' : ''
      family.to_s + mid + given.to_s
    end

    def personal_data
      {name: first['lis_person_name_full'], sortable_name: last,
       primary_email: first['lis_person_contact_email_primary']
      }
    end

    def csv_array
      short_names   = (I18n.t 'short_activity_names').stringify_keys
      #student_names = Student.get_students_by_canvas_id
      scores        = Activity.student_scores 

      map{ |activity|
        [
            short_names[activity[0]],   #  activity type
            activity[4],                #  student name
            scores[activity[1]],        #  total score
            activity[2],                #  delta
            !activity[5],                #  current (not retired)
            activity[3]                 #  updated_at
        ]
      }
    end

    def image_hash
      map{ |image|
        {
          'id'               => image.gallery_id,
          'canvas_user_id'   => image.canvas_user_id,
          'assignment_id'    => image.assignment_id,
          'submission_id'    => image.submission_id,
          'attachment_id'    => image.attachment_id,
          'author'           => image.author,
          'content_type'     => image.content_type,
          'image_url'        => image.image_url,
          'type'             => 'image',
          'date'             => image.date.to_i * 1000,
          'comments'         => image.comments_json,
          'views'            => image.views_count
        }
      }
    end

    def video_hash
      map{|media_url|
        {
          media_url.site_tag => media_url.site_id,
          'canvas_user_id'   => media_url.canvas_user_id,
          'assignment_id'    => media_url.canvas_assignment_id,
          'author'           => media_url.author,
          'id'               =>  media_url.gallery_id,
          'type'             => 'video',
          'image_url'        => media_url.thumbnail_url,
          'date'             => media_url.created_at.to_i * 1000,
          'comments'         => media_url.comments_json,
          'views'            => media_url.views_count
        }
      }
    end

  end

end
