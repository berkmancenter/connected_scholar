module EtherpadHelper

  def with_etherpad_server
    with_etherpad do |host, port, path, git, ref|
      yield host, port
    end
  end
  
  def with_etherpad_git
    with_etherpad do |host, port, path, git, ref|
      yield GitResource.new(git, path, ref)
    end
  end

  private

  def with_etherpad
    local_yaml = YAML.load_file("#{Rails.root}/config/etherpad.local.yml")
    global_yaml = YAML.load_file("#{Rails.root}/config/etherpad.global.yml")
    yield local_yaml['host'], local_yaml['port'], local_yaml['path'], global_yaml['git'], global_yaml['ref']
  end
end