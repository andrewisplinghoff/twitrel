require('rubygems')
gem('twitter4r', '0.3.1')
require('twitter')

class TimelineController < ApplicationController
  def index
    twitter = Twitter::Client.new(:login => USER, :password => PASSWORD)
    timeline = twitter.timeline_for(:friends, :count => 300)
    my_id = twitter.my(:info).id
    timeline = timeline.select { |entry| entry.user.id != my_id }
    numtweets = {}
    twitter.my(:friends).each do |friend|
      num = timeline.select { |entry| entry.user.id == friend.id }.size
      numtweets.store(friend.id, num)
    end
    @tweets = timeline.sort_by { |entry| (numtweets[entry.user.id] ** 0.6) * (Time.now - entry.created_at) }
  end
end
