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
      yield GitResource.new(git, path, ref) unless path.nil?
    end
  end

  def create_author_if_not_exists_for(user)
     with_apikey do |url, apikey|
       JsonUtil::get_json "#{url}/api/#{ETHERPAD_API_VERSION}/createAuthorIfNotExistsFor?apikey=#{apikey}&authorMapper=#{user.id}&name=#{CGI::escape(user.name)}" do |data|
         #error handling
         return data["data"]["authorID"]
       end
     end
  end

  def create_group_if_not_exists_for(document)
    with_apikey do |url, apikey|
      JsonUtil::get_json "#{url}/api/#{ETHERPAD_API_VERSION}/createGroupIfNotExistsFor?apikey=#{apikey}&groupMapper=#{document.group_id}" do |data|
        #error handling
        return data["data"]["groupID"]
      end
    end
  end

  def create_group_pad(document, text="")
    with_apikey do |url, apikey|
      JsonUtil::get_json "#{url}/api/#{ETHERPAD_API_VERSION}/createGroupPad?apikey=#{apikey}&groupID=#{document.etherpad_group_id}&padName=#{CGI::escape(document.name)}&text=#{CGI::escape(text)}" do |data|
         #error handling
        return data["code"]
      end
    end
  end

  def create_session(user, document, valid_until)
    with_apikey do |url, apikey|
      JsonUtil::get_json "#{url}/api/#{ETHERPAD_API_VERSION}/createSession?apikey=#{apikey}&groupID=#{document.etherpad_group_id}&authorID=#{user.etherpad_author_id}&validUntil=#{valid_until}" do |data|
        return data["data"]["sessionID"]
      end
    end
  end

  def get_revisions_count(pad_id)
    with_apikey do |url, apikey|
      JsonUtil::get_json "#{url}/api/#{ETHERPAD_API_VERSION}/getRevisionsCount?apikey=#{apikey}&padID=#{pad_id}" do |data|
        return data["code"] != 0 ? 0 : data["data"]["revisions"]
      end
    end
  end
  
  def delete_pad(document)
    with_apikey do |url, apikey|
      JsonUtil::get_json "#{url}/api/#{ETHERPAD_API_VERSION}/deletePad?apikey=#{apikey}&padID=#{document.etherpad_group_id}$#{CGI::escape(document.name)}" do |data|
        return data["code"]
      end
    end
  end

  private

  def with_etherpad
    unless File.exists?('config/etherpad.local.yml')
      puts "Cannot find config/etherpad.local.yml. Did you run 'rake etherpad:install'?"
      exit(1)
    end

    all_local_yaml = YAML.load_file("#{Rails.root}/config/etherpad.local.yml")
    local_yaml = all_local_yaml[Rails.env]

    global_yaml = YAML.load_file("#{Rails.root}/config/etherpad.global.yml")
    yield local_yaml['protocol'], local_yaml['host'], local_yaml['port'], local_yaml['path'], global_yaml['git'], global_yaml['ref'], local_yaml['apikey']
    true
  end

  def with_apikey
    with_etherpad do |protocol, host, port, path, git, ref, apikey|
      if apikey.nil? and !path.nil?
        unless File.exists?("#{path}/APIKEY.txt")
          puts "Cannot find #{path}/APIKEY.txt.  Did you run 'rake etherpad:run'"
          exit(1)
        end
        apikey = ""
        File.open("#{path}/APIKEY.txt") do |f|
          apikey = f.readline.strip
        end
      end
      yield "#{protocol}://#{host}:#{port}", apikey
    end
  end
end