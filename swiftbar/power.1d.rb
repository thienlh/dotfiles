#!/usr/bin/env /Users/thienle/.rbenv/shims/ruby
# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'date'

# Class represents a single power-cutoff event
class PowerCutoff
  attr_reader :date, :day_relative, :start_time, :end_time, :station_name, :reason

  def found?
    !@row.nil?
  end

  def initialize(date, station_query)
    find_power_cutoff_row(date, station_query)
    return unless found?

    set_field_values
  end

  private

  def set_field_values
    @date = @row.at_css('td:nth-child(2)').text
    @day_relative = parse_relative_day(Date.parse(@date) - Date.today)
    @start_time = @row.at_css('td:nth-child(3)').text
    @end_time = @row.at_css('td:nth-child(4)').text
    @station_name = @row.at_css('td:nth-child(5)').text
    @reason = @row.at_css('td:nth-child(6)').text
  end

  def find_power_cutoff_row(date, station_query)
    @row = Nokogiri::HTML(URI.open("https://lichcatdien.info/lich-cup-dien-dien-luc-cam-le/ngay-#{date}.html"))
                   .at_xpath("//*[@id='myTable']/tbody/tr[td[5]//text()[contains(., '#{station_query}')]]")
  end

  def parse_relative_day(num_of_day)
    case num_of_day
    when 0
      'Today'
    when 1
      'Tomorrow'
    else
      "In #{num_of_day} days"
    end
  end
end

def put_power_cutoff_info(args)
  puts "􀋩 #{args.day_relative} | size=15"
  puts '---'
  puts "Power cut-off for #{args.station_name} on #{args.date} from #{args.start_time} to #{args.end_time}"
  puts "Reason: #{args.reason}"
end

def check_power_cut_off_for(date, station_query)
  power_cutoff = PowerCutoff.new(date, station_query)
  return unless power_cutoff.found?

  put_power_cutoff_info(power_cutoff)
  # Only care about the first power cut-off found
  exit
end

station_query = ENV['STATION_QUERY'] || 'Hòa Cầm 4'
@today = Date.today
next_three_days = [@today, @today + 1, @today + 2, @today + 3]
next_three_days.each { |date| check_power_cut_off_for(date, station_query) }
# Fall back if power-cutoff found
puts '􀋥 | size=15'
puts '---'
puts 'No power-cutoff found for the next three days'
