#!/usr/bin/env /Users/thienle/.rbenv/shims/ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'date'
require 'relative_time'

url = URI("http://api.airvisual.com/v2/nearest_city?key=#{ENV['AQ_KEY']}")

http = Net::HTTP.new(url.host, url.port)
request = Net::HTTP::Get.new(url)

response = JSON.parse(http.request(request).read_body)

city = response['data']['city']
current_pollution = response['data']['current']['pollution']
aqius = current_pollution['aqius']

conditions = {
  '01d' => '􀆭', # clear sky (day)
  '01n' => '􀇀', # clear sky (night)
  '02d' => '􀇔', # few clouds (day)
  '02n' => '􀇚', # few clouds (night)
  '03d' => '􀇂', # scattered clouds
  '04d' => '􀇂', # broken clouds
  '09d' => '􀇈', # shower rain
  '10d' => '􀇖', # rain (day time)
  '10n' => '􀇜', # rain (night time)
  '11d' => '􀇞', # thunderstorm
  '13d' => '􀇦', # snow
  '50d' => '􀆷' # mist
}

ic = response['data']['current']['weather']['ic']

status = case aqius
         when 0..49
           '✓'
         when 50..99
           '✗'
         else
           '✇'
         end

puts "#{status} #{aqius} | size=15"
puts '---'
puts "#{city} #{conditions[ic]}"
puts "Updated #{RelativeTime.in_words(DateTime.parse(current_pollution['ts']).new_offset('+07:00').to_time)}"
