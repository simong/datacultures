class PopulateVimeoThumbnailUrlsWorker
  include Sidekiq::Worker

  def perform(scope)
    MediaUrl.where(site_tag: 'vimeo_id').send(scope).each do |mu|
      if mu.thumbnail_url.nil? && !mu.site_id.nil?
        thumbnail_url = Video::Metadata.thumbnail_url('vimeo_id', mu.site_id)
        mu.update_attribute(:thumbnail_url, thumbnail_url)
      end
    end
  end

end
