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
      num = timeline.select{ |entry| entry.user.id == friend.id }.size
      numtweets.store(friend.id, num)
    end
    timeline.map! { |entry| [(numtweets[entry.user.id] ** 0.6) * (Time.now - entry.created_at), entry] }
    timeline = timeline.sort_by { |entry| entry[0] }
    @tweets = timeline.map { |entry| entry[1] } 
    #puts @tweets.map { |entry| "#{entry.user.name}: #{entry.text} um #{entry.created_at.strftime('%d. %B %Y, %H:%M Uhr')}" }
  end
end
