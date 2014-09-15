require 'rubygems'
require 'twitter'

if !ENV["TEST_SOURCED_RET3453"] then
  abort "You need to source authdetails.sh before you can run this program!"
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

print "Which user's timeline do you want to see? "
user = gets.chomp

NUMBER = 10
puts "First #{NUMBER} tweets"

last_id = nil #for pagination
while true do
  options = {count: NUMBER, include_rts: true}
  #only care about this on sequential page loads
  options[:max_id] = (last_id-1) unless last_id.nil? #max_id because we're going backwards

  client.user_timeline(user, options)
  .each do |tweet| 
    puts "\033[34m#{tweet.id}\033[0m:" #should colour it blue
    puts tweet.text
    puts "-"*20
    
    if last_id.nil? then
      last_id = tweet.id
    else
      last_id = (tweet.id < last_id) ? tweet.id : last_id
    end
  end

  print "Next #{NUMBER}? (y/n) "
  if gets.chomp != 'y' then
    break
  end
end
