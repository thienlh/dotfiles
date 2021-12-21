#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'net/http'
require 'uri'
require 'json'

# Class represents a single power cutoff
class PowerCutoff
  attr_reader :url, :date, :day_relative, :start_time, :end_time, :station_name, :station_code, :reason

  def found?
    !@row.nil?
  end

  def initialize(customer_code)
    @row = find_power_cutoff_row(customer_code)
    return unless found?

    @date = Date.parse(@row['fromDate'])
    @day_relative = parse_relative_day(@date - Date.today)
    @start_time = DateTime.parse(@row['fromDate'])
    @end_time = DateTime.parse(@row['toDate'])
    @station_name = @row['stationName']
    @station_code = @row['stationCode']
    @reason = @row['reason']
  end

  private

  def find_power_cutoff_row(customer_code)
    url = URI.parse("https://cskh-staging-api.cpc.vn:8080/api/remote/outages/#{customer_code}?viewReason=true")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    # Only care about the first power cut-off found
    JSON.parse(response.read_body)[0]
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
  puts "Power cut-off for station #{args.station_name} (#{args.station_code}) on #{args.date.strftime('%d %b %Y')}"
  puts "From: #{args.start_time.strftime('%I:%M %p')}"
  puts "To: #{args.end_time.strftime('%I:%M %p')}"
  puts "Reason: #{args.reason}"
end

def check_power_cut_off_for(customer_code)
  power_cutoff = PowerCutoff.new(customer_code)
  return unless power_cutoff.found?

  put_power_cutoff_info(power_cutoff)
  exit
end

customer_code = ENV['CUSTOMER_CODE']
check_power_cut_off_for(customer_code)

# Fall back if no power-cutoff found
puts ':lightbulb: | size=15'
puts '---'
puts 'No power cutoffs found"'
