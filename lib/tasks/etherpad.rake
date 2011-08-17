require 'json'

namespace :etherpad do

  task :install, [] => [:prereqs, :checkout]

  task :prereqs, [] do
    prefix = "~/opt" # todo check PREFIX env var

    # Step 1: install Node.js
    # create tmp dir if it does not exist
    system "mkdir tmp" unless Dir.exists?("tmp")
    system "cd tmp; curl -O http://nodejs.org/dist/node-v0.4.10.tar.gz"
    system "cd tmp; tar xf node-v0.4.10.tar.gz"
    system "mkdir #{prefix}" unless Dir.exists?(prefix)
    system "cd tmp/node-v0.4.10; export PREFIX=#{prefix}; ./configure && make && make install"

    # Step 2: install npm
    system "export PATH=#{prefix}/bin:${PATH}; curl http://npmjs.org/install.sh | sh"
  end

  task :init do
    unless File.exists?("config/etherpad.local.yml")
      system "cp config/etherpad.local.yml.sample config/etherpad.local.yml"
    end
  end

  task :checkout, [] => [:init] do
    # we can't simply load use the :environment because that will check if etherpad is installed
    require "#{Rails.root}/lib/git_resource"
    require "#{Rails.root}/lib/etherpad_helper"

    include EtherpadHelper
    
    prefix = "~/opt" # todo check PREFIX env var

    with_etherpad_git do |git|
      git.checkout

      system "export PATH=#{prefix}/bin:${PATH}; cd #{git.install_path}; ./bin/installDeps.sh"
            
      # TODO adjust settings.json correctly
    end
  end
  
  task :run, [:no_check] do |t, args|
    unless args.no_check == 'true'
      puts 'Checking that correct version of etherpad-lite is installed'
      # check that we are on the correct version
      # error out if not
    end
    system "export PATH=~/opt/bin:${PATH}; cd vendor/etherpad-lite; ./bin/run.sh"
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