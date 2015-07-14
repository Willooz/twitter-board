require 'reloader/sse'

class BrowserController < ApplicationController
  include ActionController::Live

  def index
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'

    sse = Reloader::SSE.new(response.stream)

    begin
      # Listen to twitter stream
      # client = Twitter::Streaming::Client.new do |config|
      #   config.consumer_key        = ENV["twitter_consumer_key"]
      #   config.consumer_secret     = ENV["twitter_consumer_secret"]
      #   config.access_token        = ENV["twitter_access_token"]
      #   config.access_token_secret = ENV["twitter_access_token_secret"]
      # end

      # Stream new data to the client
      # @filtered_tweets = []
      # topics = ["people management", "hr", "performance", "talent" "work", "culture"]
      # client.filter(track: topics.join(",")) do |object|
      #   @filtered_tweets < object.id
      #   sse.write(data: object.text, event: 'tweet')
      # end

    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end

  def view

    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_consumer_key"]
      config.consumer_secret     = ENV["twitter_consumer_secret"]
      config.access_token        = ENV["twitter_access_token"]
      config.access_token_secret = ENV["twitter_access_token_secret"]
    end

    @tweets = twitter.search("hr, talent, people", result_type: "recent").take(10)


    people = []

    @tweets.each do |tweet|
      people << tweet.user.id
      if tweet.user_mentions?
        tweet.user_mentions.each do |mention|
          people << mention.id
        end
      end
    end

    @people = twitter.users(people).sort { |x, y| y.followers_count <=> x.followers_count }
    # @people.map do |person|
    #   {
    #     id: persion.id,
    #     name: person.screen_name,
    #     tweets: person.statuses_count
    #   }
    # end


    # .collect do |tweet|
    #   "#{tweet.user.screen_name}: #{tweet.text}"
    # end

    # @active_users = twitter.
    # @followed_users = twitter.
    # @retweeted_users
    # @favorited_users
    # @topic_users
    # @listed_users
    # @influencial_users
    # @insider_users
    # @mentioned_users = # top 100 users with highest monthly nb of mentions in past 6 months.

    # followers = twitter.followers(quality_people_ids)
    # followers_info = twitter.users_lookup(followers)

    # @retweeted_tweets = # Most retweeted tweets, (then recent RTs,) then users



  end

  def action

    # tweet
    # retweet

  end
end