# Connected Scholar

## Setup

### Install etherpad-lite

Run the following command to install Node.js, NPM and etherpad-lite

    rake etherpad:install

Node.js (one of etherpad-lite's dependencies) will be installed in ~/opt.  You can optionally set the PREFIX environment
variable to the location you would like to install Node.js.

Next, run etherpad in a seperate terminal so we can make sure it works.

    rake etherpad:run
    
And check it thusly

    rake etherpad:check

### Prepare the database

The follow command will create the application's database, schema and some preloaded data:

    rake db:setup
    
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


