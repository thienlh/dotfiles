#!/usr/bin/env /Users/thienle/.rbenv/shims/ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'date'
require 'relative_time'

url = URI('http://api.airvisual.com/v2/nearest_city?key=e637b71b-ce35-4f0a-ade7-3f22efe12d41')

http = Net::HTTP.new(url.host, url.port)
request = Net::HTTP::Get.new(url)

response = JSON.parse(http.request(request).read_body)

city = response['data']['city']
current_pollution = response['data']['current']['pollution']
aqius = current_pollution['aqius']

conditions = {
  '01d' => '☀️',
  '01n' => '🌕',
  '02d' => '🌤',
  '02n' => '🌜',
  '03d' => '🌥',
  '04d' => '☁️',
  '09d' => '🌧',
  '10d' => '🌦',
  '10n' => '☔️',
  '11d' => '⛈',
  '13d' => '🌨',
  '50d' => '🌫'
}

ic = response['data']['current']['weather']['ic']

status = '✇'
case aqius
when 0..49
  status = '✓'
when 50..99
  status = '✗'
end

puts "#{status} #{aqius} | size=15"
puts '---'
puts "#{city} #{conditions[ic]} (updated #{RelativeTime.in_words(DateTime.parse(current_pollution['ts']).new_offset('+07:00').to_time)})"
