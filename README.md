# Connected Scholar

## Setup

### Install Ruby and Rails

This project is primarily a Ruby on Rails application.  As such, you'll have to install Ruby and Rails.  If you are not
familiar with either of these, we suggest reading [this Rails guide](http://guides.rubyonrails.org/getting_started.html).

First, make sure you are using Ruby 1.9.2 by running the following command.  You should see some output like the one
below.

    $ ruby -v
    ruby 1.9.2p290 (2011-07-09 revision 32553) [x86_64-darwin11.0.1]

Next, check to make sure RubyGems installed by running the following command, and look for similar output:

    $ gem -v
    1.8.6

If the commands above were not succesful, then [read through this guide](http://rubyonrails.org/download) on downloading
and installing Ruby and RubyGems.

Checkout johnson from https://github.com/inukshuk/johnson.git.
  
  git clone https://github.com/inukshuk/johnson.git
  cd johnson
  git checkout experimental
  rake compile
  rake gem
  gem install pkg/johnson-2.0.0.pre3.gem

Next, install Bundler.  This is a tool that will manage your RubyGems for this application.  Run the following command:

    gem install bundler

With bundler installed, you can now use it to get all of the application's dependencies. Change directories to the
location you have this project checked out, and run the following command:

    bundle install

This will install Rails as well as a host of other Gems.

### Install etherpad-lite

(Note: these steps are only designed to work on *nix systems.  And they have only been tested on Mac OS X).

Run the following command to install Node.js, NPM and etherpad-lite

    rake etherpad:install

Node.js (one of etherpad-lite's dependencies) will be installed in ~/opt.  You can optionally set the PREFIX environment
variable to the location you would like to install Node.js.

Next, run etherpad in a seperate terminal so we can make sure it works.

    rake etherpad:run
    
And check it thusly

    rake etherpad:check

### Prepare the database

The follow commands will create the application's database, schema and some preloaded data:

    rake db:migrate
    rake db:seed
    
## Run

If the etherpad server is not already running, execute this command:

    rake etherpad:run

The run the rails application:

    rails server

Both processes must be working in order for the collaborative editing environment to work.  You can run the Rails
application without the etherpad server (it will prompt you at start up to make sure thats what you want).  But some
things will not work.

## Login

The following default user will have been created for you:

+  admin@test.com / password

## Upgrade

Occasionally, the version of etherpad we use will change.  If this happens, the commands above will prompt you to
upgrade etherpad before continuing.   To do this, run the following command:

    rake etherpad:checkout

In the very rare event that the the etherpad dependencies change, you will have to reinstall the entire suite:

    rake etherpad:uninstall
    rake etherpad:install


