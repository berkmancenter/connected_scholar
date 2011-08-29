require 'rest_client'
require 'json'

module EtherpadUtil

  def with_etherpad_server
    with_etherpad do |protocol, host, port, path, git, ref|
      yield protocol, host, port
    end
  end

  def with_etherpad_url
    with_etherpad do |protocol, host, port, path, git, ref|
      yield "#{protocol}://#{host}:#{port}"
    end
  end
  
  def with_etherpad_git
    with_etherpad do |protocol, host, port, path, git, ref|
      yield GitResource.new(git, path, ref)
    end
  end

  def create_author_if_not_exists_for(user)
     with_apikey do |url, apikey|
       get_json "#{url}/api/1/createAuthorIfNotExistsFor?apikey=#{apikey}&authorMapper=#{user.id}&name=#{CGI::escape(user.name)}" do |data|
         return data["data"]["authorID"]
       end
     end
  end

  private

  def with_etherpad
    unless File.exists?('config/etherpad.local.yml')
      puts "Cannot find config/etherpad.local.yml. Did you run 'rake etherpad:install'?"
      exit(1)
    end

    local_yaml = YAML.load_file("#{Rails.root}/config/etherpad.local.yml")
    global_yaml = YAML.load_file("#{Rails.root}/config/etherpad.global.yml")
    yield local_yaml['protocol'], local_yaml['host'], local_yaml['port'], local_yaml['path'], global_yaml['git'], global_yaml['ref']
    true
  end

  def with_apikey
    with_etherpad do |protocol, host, port, path, git, ref|
      unless File.exists?("#{path}/APIKEY.txt")
        puts "Cannot find #{path}/APIKEY.txt.  Did you run 'rake etherpad:run'"
        exit(1)
      end
      apikey = ""
      File.open("#{path}/APIKEY.txt") do |f|
        apikey = f.readline.strip
      end
      yield "#{protocol}://#{host}:#{port}", apikey
    end
  end

  #need to move this to a common util lib once library cloud is committed
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