class Video::Metadata

  def self.thumbnail_url(service_tag, id)
    if service_tag =~  /\Ayoutube_id/
      'https://img.youtube.com/vi/' + id + '/hqdefault.jpg'
    elsif service_tag =~ /\Avimeo_id/
      f = Faraday.new(url: "http://vimeo.com/")
      f.response :json, :content_type => 'application/json'
      body = f.get("api/v2/video/#{id}.json").try(:body)
      body.first['thumbnail_medium'].sub('http://', 'https://')
    else
      ''
    end
  end

end
