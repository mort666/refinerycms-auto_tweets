require 'refinerycms-core'

module Refinery
  module AutoTweets

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Setting.find_or_set(:twitter_oauth_token,
          '000000000-xxxxxxxxyour_twitter_oauth_tokenxxxxxxxx')
        Refinery::Setting.find_or_set(:twitter_oauth_token_secret,
          'xxxxxyour_twitter_oauth_token_secretxxxx')
        Refinery::Setting.find_or_set(:twitter_consumer_key,
          'xxxxconsumer_keyxxxx')
        Refinery::Setting.find_or_set(:twitter_consumer_secret,
          'xxxxxxxxxxtwitter_consumer_secretxxxxxxxx')
        Refinery::Setting.find_or_set(:twitter_message,
          '{title}: {stub}. {url}')
      end

      require 'iwa_extension/auto_tweet'
      config.to_prepare do
        Refinery::Blog::Post.class_eval do
          include ::IwaExtension::AutoTweet
        end
      end
    end
  end
end
