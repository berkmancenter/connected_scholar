module LibraryCloudUtil

  def item_search(search_type, query)
    with_librarycloud do |key, url|
      JsonUtil::get_json "#{url}/api/item/?key=#{key}&search_type=#{search_type}&query=#{CGI::escape(query)}"
    end
  end

  private

  def with_librarycloud
    yaml = YAML.load_file("#{Rails.root}/config/librarycloud.yml")
    yield yaml['key'], yaml['url']
  end
end