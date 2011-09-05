module SearchUtil

  def item_search(search_type, query)
    with_librarycloud do |key, url|
      JsonUtil::get_json "#{url}/api/item/?key=#{key}&search_type=#{search_type}&query=#{CGI::escape(query)}"
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