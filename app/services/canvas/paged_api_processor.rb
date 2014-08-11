class Canvas::PagedApiProcessor

  attr_accessor  :handler

  def initialize(config)
    @handler   = config[:handler]     ## Ruby class to handle the response body
  end

  def call(url) ## callER should be responsible for the per_page parameter on URL (or add a field in config)

    results = handler.request_object.request.get(url)

    if results.headers['link'].kind_of? String
      links = links_hash(results.headers['link'])
      paginated = true
    else
      paginated = false
    end

    more_to_process = true
    return_values = []
    while more_to_process do
      return_values << handler.call(results.body)
      if paginated && links['next'] && (links['next'] != links['current'])
        results = handler.request_object.request.get(links['next'])
        links = links_hash(results.headers['link'])
      else
        more_to_process = false
      end
    end
    return_values

  end

  private

  def links_hash(raw_links)
    raw_links.gsub(/\<|\>/,'').split(/,/).map{|a| a.split(/\; rel=\"/)}.map{|b| [b[1].chomp('"'), b[0]]}.to_h
  end

end