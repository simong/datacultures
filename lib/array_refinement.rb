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

    #   'author','date','content_type','image_url', 'gallery_id']


    def image_hash
      map{ |image|
        {
          'id'                  => image.gallery_id,
          'canvas_user_id'      => image.canvas_user_id,
          'assignment_id'       => image.assignment_id,
          'submission_id'       => image.submission_id,
          'attachment_id'       => image.attachment_id,
          'author'              => image.author,
          'conent_type'         => image.content_type,
          'image_url'           => image.image_url,
          'type'                => 'image',
          'date'                => image.date.to_i * 1000,
          'comments'            => image.comments_json
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
          'image_url'        => Video::Metadata.thumbnail_url(media_url.site_tag, media_url.site_id),
          'date'             => media_url.created_at.to_i * 1000,
          'comments'         => media_url.comments_json
        }
      }

    end

  end

end
