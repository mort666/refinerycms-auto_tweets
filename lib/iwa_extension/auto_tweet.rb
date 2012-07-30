require 'twitter'

module IwaExtension
  module Tweeter
    def self.post_tweet_message(title, url)
      ::Twitter.configure do |config|
        config.consumer_key = Refinery::Setting.get(:twitter_consumer_key)
        config.consumer_secret = Refinery::Setting.get(:twitter_consumer_secret)
        config.oauth_token = Refinery::Setting.get(:twitter_oauth_token)
        config.oauth_token_secret = Refinery::Setting.get(:twitter_oauth_token_secret)
      end
      message = Refinery::Setting.get(:twitter_message)
      message = message.gsub('{title}', title).gsub('{url}', url)
      ::Twitter.update(message)
    end
  end

  module AutoTweet
    def should_tweet?
      live? && post_tweet && !tweeted
    end
    
    def tweet_url
      engine = "Refinery::Core::Engine".constantize
      engine.routes.default_url_options[:host] = Rails.application.routes.default_url_options[:host]
      all_routes = engine.routes.url_helpers.blog_post_url(self)
    end
    
    def post_tweet!
      url = self.tweet_url
      begin
        ::IwaExtension::Tweeter.post_tweet_message(title, url)
        self.tweeted = true
        self.save
      rescue
      end
    end
  end
end

