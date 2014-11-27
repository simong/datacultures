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
      self.numerize_keys!(keys_to_numerize: %w<comment_count likes dislikes views>)
    end

    def numerize_comment_fields!
      self.numerize_keys!(keys_to_numerize: %w<created_at author_canvas_user_id>)
    end

    def numerize_keys!(keys_to_numerize:)
      keys_to_numerize.each do |numerizable_key|
        self[numerizable_key] = self[numerizable_key].to_i
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
