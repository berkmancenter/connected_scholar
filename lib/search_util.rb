module SearchUtil

  def item_search(search_type, query, limit=25, start=0, sort=nil, filters=[])
    with_librarycloud do |key, url|
      search_url = "#{url}/api/item/?key=#{key}&search_type=#{search_type}&query=#{CGI::escape(query)}&limit=#{limit}&start=#{start}"
      unless sort.nil? or sort == ""
        search_url += "&sort=#{sort}%20desc"
      end
      filters.each do |f|
        search_url += "&filter=#{f[:filter_type]}:#{CGI::escape(f[:filter])}"
      end
      Rails.logger.info "LC => #{search_url}"
      x = JsonUtil::get_json search_url
      Rails.logger.info "LibraryCloud service returned a response"
      x
    end
  end

  def item_link(hollis_id)
    with_hollis do |url, item_prefix|
      "#{url}#{item_prefix}#{hollis_id}"
    end
  end

  private

  def with_librarycloud
    yaml = YAML.load_file("#{Rails.root}/config/librarycloud.yml")
    yield yaml['key'], yaml['url']
  end

  def with_hollis
    yaml = YAML.load_file("#{Rails.root}/config/hollis.yml")
    yield yaml['url'], yaml['item_prefix']
  end
end