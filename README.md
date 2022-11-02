# README

Shockwave Kickers

### First Time User guide to install dependencies

* Ruby version: 3.1.2
* System dependencies
  Install Yarn, Node, Ruby and Rails, Postgres, imagemagick

To Install Ruby, Rails and Bundler, followed this: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-macos

To Install imagemagick:
`brew install imagemagick`

To install Postgres:
`brew install postgresql`

Start Postgres each time at login:
`brew services start postgresql`

After install prerequisites, follow the following steps for step time users:

1) `bundle install`

* Database initialization

2) `rake db:create`
3) `rake db:migrate`

### Local Deployment

* To start rails server locally:

1) export ENV variables:
    ```
        export SENDMAIL_PASSWORD=LOOK_AT_SLACK_CHANNEL
        export SENDMAIL_USERNAME=shockwavekickers@gmail.com
        export MAIL_HOST=gmail.com
    ```
2) `rails s`

* How to run the test suite
  `rake test`

This command should also store test coverage.

* How to run open coverage
  `open coverage/index.html`

* Deployment instructions to Heroku
  Automatic deployment is done!!


### FrontEnd

To look at the frontend components:

App -> assets -> Views

Debugging Tips:

* If bootstrap is not loading, call the following command:
 `bundle exec rake assets:precompile`

* If db:migrate doesn't work, call the following command before db:migrate again:
 `rake db:reset`


 #### Store images in S3 instead of locally while developing

1) Go to development.rb and update:
    `config.active_storage.service = :local`
2) Go to storage.yml, change amazon bucket name to `shockwavekickers-dev`
3) Export RAILS_MASTER_KEY=LOOK_AT_SLACK_CHANNEL
4) Run rails server start command
