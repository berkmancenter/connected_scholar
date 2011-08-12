# maybe the initializer should start etherpad?

# TODO check for correct version as well. 
# we also need to move this somewhere that the rake task can also use it.
# and base the url on the settings.json
unless system 'curl --silent http://localhost:9001 >/dev/null'
  print "Etherpad isn't running! Do you want to continue? (y/n): "
  answer = STDIN.gets
  unless answer.strip == 'y'
    puts 'Aborting startup...'
    exit(1)
  end
end 