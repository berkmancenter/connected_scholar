include EtherpadUtil

unless ENV['NO_ETHERPAD']
  with_etherpad_git do |git|
    unless git.ref_checked_out?
      puts "Etherpad is not on the correct revision! Run 'rake etherpad:checkout'"
      exit(1)
    end
  end

  with_etherpad_server do |protocol, host, port|
    unless system "curl --silent #{protocol}://#{host}:#{port} >/dev/null"
      print "Etherpad isn't running! Do you want to continue? (y/n): "
      answer = STDIN.gets
      unless answer.strip == 'y'
        puts 'Aborting startup...'
        exit(1)
      end
    end
  end
end
VALID_UNTIL_DAYS=1
ETHERPAD_API_VERSION=1