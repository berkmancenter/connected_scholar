require 'rest_client'
require 'json'

module JsonUtil
  def self.get_json(url, timeout=5)
    RestClient::Request.execute(
        :method => "get",
        :url =>url,
        :content_type => :json,
        :accept => :json,
        :cache_control => "no-cache",
        :timeout => timeout
    ) do |response|
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

  def self.get_html(url)
    RestClient.get url, {
        :content_type => :html,
        :accept => :html,
        :cache_control => "no-cache"
    } do |response|
      if response and !response.blank? and response != 'null'
        if block_given?
          yield response
        else
          return response
        end
      else
        return nil
      end
    end
  end
end