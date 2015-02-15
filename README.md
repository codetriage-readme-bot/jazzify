#Jazzify

This application is compatible with the latest version of rails and all gems in the Gemfile.

To run this application, install postgresql on your machine.

Production: https://ottawajazzify.herokuapp.com/<br>
Test: https://ottawajazzifytest.herokuapp.com/

#####Once you have this repository cloned on your machine

```bash
bundle install
gem update
rake db:setup
bundle exec rails server
``` 

To generate an Entity Relationship Diagram, execute <code>rake erd</code>. Please don't commit the resulting PDF.
