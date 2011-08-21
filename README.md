# Connected Scholar

## Setup

### Install etherpad-lite

Run the following command to install Node.js, NPM and etherpad-lite

    rake etherpad:install

In a seperate terminal, run etherpad so we can make sure it works.

    rake etherpad:run
    
And check it thusly

    rake etherpad:check

### Prepare the database

The following commands will create the application's database, schema and some preloaded data:

    rake db:migrate
    rake db:seed

## Login

The following default user will have been created for you:

+  admin@test.com / password
    
