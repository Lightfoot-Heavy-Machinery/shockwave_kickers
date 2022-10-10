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

* Database initialization

2) `rake db:create`

3) `rake db:migrate`

* To start rails server locally:

`rails s`

* How to run the test suite
`rake test`

This command should also store test coverage.

* How to run open coverage
`open coverage/index.html`

* Deployment instructions to Heroku
Automatic deployment is done!!
