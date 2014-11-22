class Clean < Thor

  require 'thor/rails'
  include Thor::Rails

  desc "vimeo", "Repopulate Vimeo thumbnail URLs"
  def vimeo
    PopulateVimeoThumbnailUrlsWorker.perform_async(:all)
  end

end
