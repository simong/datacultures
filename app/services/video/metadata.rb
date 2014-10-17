class Video::Metadata

  def self.thumbnail_url(service_tag, id)
    if service_tag == 'youtube_id'
      'https://img.youtube.com/vi/' + id + '/hqdefault.jpg'
    else
      f = Faraday.new(url: "http://vimeo.com/")
      f.response :json, :content_type => 'application/json'
      f.get("api/v2/video/#{id}.json").body.first['thumbnail_medium']
    end
  end

end

