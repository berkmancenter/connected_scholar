require 'rest_client'
require 'json'

module JsonUtil
  def self.get_json(url)
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