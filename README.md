# README

Shockwave Kickers

* Ruby version: 3.1.2

* System dependencies
Install Yarn, Node, Ruby and Rails, Postgres

To Install Ruby, Rails and Bundler, followed this: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-macos

To install Postgres:
`brew install postgresql`

Start Postgres each time at login:
`brew services start postgresql`

After install prerequisites, follow the following steps for step time users:

1) `bundle install`

2) `bundle exec rake webpacker:install`

3) `bundle exec rake webpacker:install:react`

4) `yarn install`

* Database initialization

5) `rake db:create`

6) `rake db:migrate`

* To start rails server locally:

`rails s`

* How to run the test suite
TBD

* Deployment instructions to AWS/Heroku
TBD
* ...
