namespace :etherpad do

  task :install do
    # TODO make sure its not already installed
    
    # Step 1: install Node.js
    system "cd tmp; curl -O http://nodejs.org/dist/node-v0.4.10.tar.gz"
    system "cd tmp; tar xf node-v0.4.10.tar.gz"
    system "cd tmp/node-v0.4.10; ./configure && make && make install"
    
    # Step 2: install npm
    system "curl http://npmjs.org/install.sh | sh"

    # Step 3: clone etherpad
    system "git clone git://github.com/Pita/etherpad-lite.git vendor/etherpad-lite"
    
    # Step 4: setup etherpad
    # TODO adjust settings.json correctly
    system "cd vendor/etherpad-lite; ./bin/installDeps.sh"
  end
  
  task :run, [:no_check] do |t, args|
    unless args.no_check == 'true'
      puts 'Checking that correct version of etherpad-lite is installed'
      # check that we are on the correct version
      # error out if not
    end
    system "cd vendor/etherpad-lite; ./bin/run.sh"
  end
  
  task :check do
    # TODO check the version of the code
    
    # TODO need to base this on the settings.json
    if system 'curl --silent http://localhost:9001 >/dev/null'
      puts 'Etherpad is running correctly!'
    else
      puts "Etherpad isn't working!"
    end      
  end
  
  task :pull do
    # TODO pull a specific version (so we are all on the code)
    system 'cd vendor/etherpad-lite; git pull origin master'
  end
end