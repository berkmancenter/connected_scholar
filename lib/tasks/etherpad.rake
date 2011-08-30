require 'json'

namespace :etherpad do

  DEFAULT_PREFIX = 'vendor/node'

  task :uninstall, [] => [:uninstall_prereqs] do
    system "rm -rf vendor/etherpad-lite"
    puts "Successfully uninstalled etherpad"
  end

  task :uninstall_prereqs do
    prefix = ENV['PREFIX']
    prefix ||= DEFAULT_PREFIX
    prefix = File.expand_path(prefix)

    if File.exists?(File.join(prefix, "bin/node"))
      system "export PATH=#{prefix}/bin:${PATH}; export PREFIX=#{prefix}; npm uninstall npm -g"

      system "mkdir tmp" unless Dir.exists?("tmp")

      unless File.exists?("tmp/node-v0.4.10.tar.gz")
        system "cd tmp; curl -O http://nodejs.org/dist/node-v0.4.10.tar.gz"
      else
        puts "Using previously downloaded node-v0.4.10.tar.gz"
      end
      
      system "cd tmp; tar xf node-v0.4.10.tar.gz"
      system "cd tmp/node-v0.4.10; export PREFIX=#{prefix}; ./configure && make uninstall"
    end
    puts "Successfully uninstalled prerequisites"
  end

  task :install, [] => [:install_prereqs, :checkout]

  task :install_prereqs, [] do
    prefix = ENV['PREFIX']
    prefix ||= DEFAULT_PREFIX
    prefix = File.expand_path(prefix)

    if File.exists?(File.join(File.expand_path(prefix), "bin/node"))
      puts "Etherpad prerequisites are already installed. Run 'rake etherpad:uninstall' if you need to refresh them."
    else
      # Step 1: install Node.js
      # create tmp dir if it does not exist
      system "mkdir tmp" unless Dir.exists?("tmp")

      unless File.exists?("tmp/node-v0.4.10.tar.gz")
        system "cd tmp; curl -O http://nodejs.org/dist/node-v0.4.10.tar.gz"
      else
        puts "Using previously downloaded node-v0.4.10.tar.gz"
      end

      system "cd tmp; tar xf node-v0.4.10.tar.gz"
      system "mkdir #{prefix}"
      system "cd tmp/node-v0.4.10; export PREFIX=#{prefix}; ./configure && make && make install"

      # Step 2: install npm
      system "export PATH=#{prefix}/bin:${PATH}; export PREFIX=#{prefix}; curl http://npmjs.org/install.sh | clean=yes sh"
      
    end
  end

  task :init do
    unless File.exists?("config/etherpad.local.yml")
      system "cp config/etherpad.local.yml.sample config/etherpad.local.yml"
    end
  end

  task :checkout do
    ENV['NO_ETHERPAD'] = '1'
    Rake::Task['etherpad:_checkout_'].invoke
  end

  task :_checkout_, [] => [:init, :environment] do
    include EtherpadUtil

    prefix = ENV['PREFIX']
    prefix ||= DEFAULT_PREFIX
    prefix = File.expand_path(prefix)

    with_etherpad_git do |git|
      git.checkout
      #install sqlite3 and pg
      system "export PATH=#{prefix}/bin:${PATH}; export PREFIX=#{prefix}; cd #{git.install_path}; npm install sqlite3"
      system "export PATH=#{prefix}/bin:${PATH}; export PREFIX=#{prefix}; cd #{git.install_path}; npm install pg"
      
      system "export PATH=#{prefix}/bin:${PATH}; export PREFIX=#{prefix}; cd #{git.install_path}; ./bin/installDeps.sh"

      # temporary until our ueberDB patch makes it into etherpad-lite
      system "cp etc/package.json vendor/etherpad-lite/node_modules/ueberDB"
      system "cp etc/postgres_db.js vendor/etherpad-lite/node_modules/ueberDB"
      system "cp etc/run.sh vendor/etherpad-lite/bin"

      # TODO adjust settings.json correctly
    end
  end
  
  task :run, [:no_check] do |t, args|
    prefix = ENV['PREFIX']
    prefix ||= DEFAULT_PREFIX
    prefix = File.expand_path(prefix)
    
    unless args.no_check == 'true'
      puts 'Checking that correct version of etherpad-lite is installed'
      # check that we are on the correct version
      # error out if not
    end
    system "export PATH=#{prefix}/bin:${PATH}; export PREFIX=#{prefix}; cd vendor/etherpad-lite; ./bin/run.sh"
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