include EtherpadHelper

unless ENV['NO_ETHERPAD']
  with_etherpad_server do |host, port|
    unless system "curl --silent http://#{host}:#{port} >/dev/null"
      print "Etherpad isn't running! Do you want to continue? (y/n): "
      answer = STDIN.gets
      unless answer.strip == 'y'
        puts 'Aborting startup...'
        exit(1)
      end
    end
  end
end