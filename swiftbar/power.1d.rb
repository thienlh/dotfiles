#!/usr/bin/env /Users/thienle/.rbenv/shims/ruby
# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'date'

station_query = ENV['STATION_QUERY'] || 'Hòa Cầm 4'
@today = Date.today

def check_power_cut_off_for(date, station_query)
  doc = Nokogiri::HTML(URI.open("https://lichcatdien.info/lich-cup-dien-dien-luc-cam-le/ngay-#{date}.html"))
  row = doc.at_xpath("//*[@id='myTable']/tbody/tr[td[5]//text()[contains(., '#{station_query}')]]")
  return if row.nil?

  localized_date = row.at_css('td:nth-child(2)').text
  start_time = row.at_css('td:nth-child(3)').text
  end_time = row.at_css('td:nth-child(4)').text
  station_name = row.at_css('td:nth-child(5)').text
  reason = row.at_css('td:nth-child(6)').text
  num_of_day = Date.parse(localized_date) - @today
  relative_day = case num_of_day
                 when 0
                   'Today'
                 when 1
                   'Tomorrow'
                 else
                   "In #{num_of_day} days"
                 end

  puts "􀋩 #{relative_day}"
  puts '---'
  puts "Power cut-off for #{station_name} on #{localized_date} from #{start_time} to #{end_time}"
  puts "Reason: #{reason}"
  # only care about the first power cut-off found
  exit
end

next_three_days = [@today, @today + 1, @today + 2, @today + 3]
next_three_days.each { |date| check_power_cut_off_for(date, station_query) }
puts '􀋥'
