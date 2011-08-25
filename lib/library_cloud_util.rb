require 'rest_client'
require 'json'

module LibraryCloudUtil

  def item_search(search_type, query)
    with_librarycloud do |key, url|
      get_json "#{url}/api/item/?key=#{key}&search_type=#{search_type}&query=#{CGI::escape(query)}"
    end
  end

  def get_item(item_id)
    with_librarycloud do |key, url|
      get_json "#{url}/api/item/#{item_id}?key=#{key}"
    end
  end

  private

  def with_librarycloud
    yaml = YAML.load_file("#{Rails.root}/config/librarycloud.yml")
    yield yaml['key'], yaml['url']
  end

  def get_json(url)
    RestClient.get url, {
        :content_type => :json,
        :accept => :json,
        :cache_control => "no-cache"
    } do |response|
      if response and !response.blank? and response != 'null'
        if block_given?
          yield JSON.parse(response)
        else
          return JSON.parse(response)
        end
      else
        return nil
      end
    end
  end

end