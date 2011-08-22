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

## Login

The following default user will have been created for you:

+  admin@test.com / password
    
