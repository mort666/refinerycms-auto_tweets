# Auto Tweets engine for Refinery CMS.

## Introduction

Posts Tweets for blog posts within RefineryCMS 2.x.x, requires Twitter account and Bit.ly API account for URL Shortening.

## Installing

Add refinerycms-auto_tweets to your Gemfile

    gem 'refinerycms-auto_tweets', :git => 'git://github.com/mort666/refinerycms-auto_tweets.git'

Run generator

    bundle exec rails g refinerycms_auto_tweets

*Please check your `config/application.rb` for observer configuration*

Set default host URL. Change accordingly for environment.

    Rails.application.routes.default_url_options[:host]= 'lvh.me:3000'

Run migration

    bundle exec rake db:migrate

Go to Refinery admin and set appropriate Twitter API key.

### Set up Cron Job for blog published in the future.

Set your cron job to run the following task.

    bundle exec rake refinery:auto_tweets:cron

## Standalone Gem set up

### How to build this engine as a gem

    gem build refinerycms-auto_tweets.gemspec
    gem install refinerycms-auto_tweets.gem


## Authors

Original refinerycms-auto_tweets release for 1.7.x Refinery CMS authored by

* Jussi Virtanen: http://github.com/iwalabs
* Timo Lehto: http://github.com/iwalabs
* Joe Rerngniransatit: http://github.com/iwalabs

Modifications for Refinery CMS 2.x.x by

* Stephen Kapp: https://github.com/mort666/

## License

Copyright 2012 Iwa Labs Ltd. Licensed under the MIT License.
Modifications Copyright 2012 Stephen Kapp. Licensed under the MIT License.