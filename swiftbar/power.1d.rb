#!/usr/bin/env /opt/homebrew/opt/ruby/bin/ruby
# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'date'

# Class represents a single power cutoff
class PowerCutoff
  attr_reader :date, :day_relative, :start_time, :end_time, :station_name, :reason

  def found?
    !@row.nil?
  end

  def initialize(station_query)
    find_power_cutoff_row(station_query)
  end

  private

  def text_at(selector)
    @row.at_css(selector).text
  end

  def find_power_cutoff_row(station_query)
    @row = Nokogiri::HTML(URI.open('https://ithongtin.com/lich-cup-dien/da-nang/cam-le'))
                   .at_xpath("//*[@id='myTable']/tbody/tr[td[5]//text()[contains(., '#{station_query}')]]")
    return unless found?

    @date = text_at('td:nth-child(2)')
    @day_relative = parse_relative_day(Date.parse(@date) - Date.today)
    @start_time = text_at('td:nth-child(3)')
    @end_time = text_at('td:nth-child(4)')
    @station_name = text_at('td:nth-child(6)')
    @reason = text_at('td:nth-child(7)').gsub(/\R+/, ' ')
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
  puts ":lightbulb.slash.fill: #{args.day_relative} | size=15"
  puts '---'
  puts "Power cut-off for #{args.station_name} on #{args.date} from #{args.start_time} to #{args.end_time}"
  puts "Reason: #{args.reason}"
end

def check_power_cut_off_for(station_query)
  power_cutoff = PowerCutoff.new(station_query)
  return unless power_cutoff.found?

  put_power_cutoff_info(power_cutoff)
  # Only care about the first power cut-off found
  exit
end

station_query = ENV['STATION_QUERY'] || 'Hòa Cầm 4'
check_power_cut_off_for(station_query)

# Fall back if no power-cutoff found
puts ':lightbulb: | size=15'
puts '---'
puts 'No power cutoffs found for the next three days'
