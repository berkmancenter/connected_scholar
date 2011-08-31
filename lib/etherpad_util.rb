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

  private

  def with_etherpad
    unless File.exists?('config/etherpad.local.yml')
      puts "Cannot find config/etherpad.local.yml. Did you run 'rake etherpad:install'?"
      exit(1)
    end

    all_local_yaml = YAML.load_file("#{Rails.root}/config/etherpad.local.yml")
    local_yaml = all_local_yaml[Rails.env]

    global_yaml = YAML.load_file("#{Rails.root}/config/etherpad.global.yml")
    yield local_yaml['protocol'], local_yaml['host'], local_yaml['port'], local_yaml['path'], global_yaml['git'], global_yaml['ref']
    true
  end
end