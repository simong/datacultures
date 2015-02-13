module StringRefinement

  refine String do

    def extract_site_and_slug
      case self
        when /www\.youtube\.com\/embed/  # embed YT URL
          youtube_embed
        when /youtu\.be\//               # short YT URL
          youtube_short
        when /www.\youtube\.com\//       # 'regular' YT URL
          youtube
        when /vimeo/
          vimeo
        else
          nil
      end
    end

    def youtube_embed
      self =~ /www\.youtube\.com\/embed\/([a-zA-Z0-9_-]+)/
      $1 ? {site_tag: 'youtube_id', site_id: $1} : nil
    end

    def youtube_short
      self =~ /youtu\.be\/([a-zA-Z0-9_-]+)/
      $1 ?  {site_tag: 'youtube_id', site_id: $1} : nil
    end

    def youtube
      self =~ /\?v=([a-zA-Z0-9_-]+)/
      $1 ?  {site_tag: 'youtube_id', site_id: $1} : nil
    end

    def vimeo
      self =~ /vimeo\.com(?:(?:\/channels\/[0-9a-z]+)|(?:groups\/[a-z]+\/videos)|(?:video))?\/?(\d+)/
      $1 ?  {site_tag: 'vimeo_id', site_id: $1} : nil
    end

    def slash_bracket(const_part)
      empty? ? self : const_part + '/' + self
    end

    def gallery_model_class
      case self
        when /\Aimage-/
          Attachment
        when /\Avideo-/
          MediaUrl
        when /\Aurl-/
          GenericUrl
      end
    end


  end

end
