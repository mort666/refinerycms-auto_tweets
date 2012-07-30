require 'twitter'
require 'httparty'

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
      message = message.gsub('{title}', title).gsub('{url}', ::Bitly.shorten(url))
      ::Twitter.update(message)
    end
  end

  module Bitly
    include HTTParty
    base_uri 'api.bit.ly'
    format :json

    # Usage: Bitly.shorten("http://example.com")
    def self.shorten(url)
      response = get('/v3/shorten', :query => required_params.merge(:longUrl => url ))
      response['data']["url"]
    end

    # Usage: Bitly.stats("http://bit.ly/18LNRV")  
    def self.clicks(url)
      response = get('/v3/clicks', :query => required_params.merge(:shortUrl => url))
      response['data']['clicks'][0]['user_clicks']
    end

    # your bit.ly api key can be found at http://bit.ly/a/your_api_key
    def self.required_params
      {:version => "2.0.1", :login => "o_2348nmppbm", :apiKey => 'R_acc53a3aabe1a1b0de5f34e22566a308'}
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
      rescue Exception => e 
        puts e.message  
        puts e.backtrace.inspect
      end
    end
  end
end

