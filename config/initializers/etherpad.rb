# maybe the initializer should start etherpad?

unless File.exists?('config/etherpad.local.yml')
  puts "Cannot find config/etherpad.local.yml. Did you run 'rake etherpad:install'?"
  exit(0)
end

unless system 'curl --silent http://localhost:9001 >/dev/null'
  print "Etherpad isn't running! Do you want to continue? (y/n): "
  answer = STDIN.gets
  unless answer.strip == 'y'
    puts 'Aborting startup...'
    exit(1)
  end
end 