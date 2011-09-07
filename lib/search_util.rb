module SearchUtil

  def item_search(search_type, query, filter_type=nil, filter=nil)
    with_librarycloud do |key, url|
      search_url = "#{url}/api/item/?key=#{key}&search_type=#{search_type}&query=#{CGI::escape(query)}"
      if filter_type
        search_url += "&filter=#{filter_type}:#{CGI::escape(filter)}"
      end
      JsonUtil::get_json search_url
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