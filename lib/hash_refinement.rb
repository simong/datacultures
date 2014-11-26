module HashRefinement

  refine Hash do

    def correct_liked_values!
      liked_state  = nil
      if self['disliked'].nil?  && self['liked']    && (self['liked'] == 't')
        liked_state = true
      elsif self['liked'].nil?  && self['disliked'] && (self['disliked'] == 't')
        liked_state = false
      end
      self['liked'] = liked_state
      delete('disliked') if has_key?('disliked')
      self
    end

    def transmogrify_video_tags!
      self[self['site_tag']] = self['site_id']
      self.except!('site_tag', 'site_id', nil)  # if site_tag did not exist, do not create one with nil key
    end

    def numerize_count_values!
      ['comment_count', 'likes', 'dislikes', 'views'].each do |count_key|
          self[count_key] = self[count_key].to_i
      end
      self
    end

    def image_transform!
      correct_liked_values!.numerize_count_values!
    end

    def video_transform!
      image_transform!.transmogrify_video_tags!
    end

  end

end
