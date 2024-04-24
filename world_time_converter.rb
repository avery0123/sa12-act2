require 'httparty'
require 'json'

def fetch_time_in_timezone(area, location)
  url = "http://worldtimeapi.org/api/timezone/#{area}/#{location}"

  response = HTTParty.get(url)

  if response.code == 200
    json_data = JSON.parse(response.body)
    {
      area: json_data['timezone'],
      current_date: json_data['datetime'].split('T')[0],
      current_time: json_data['datetime'].split('T')[1].split('.')[0]
    }
  else
    puts "Error: #{response.code} - #{response.message}"
    nil
  end
end

def display_time_in_timezone(time_data)
  return puts "No time data found." if time_data.nil?

  puts "The current time in #{time_data[:area]} is #{time_data[:current_date]} #{time_data[:current_time]}"
end


if ARGV.length < 2
  puts "Usage: ruby world_time_converter.rb <area> <location>"
  exit
end

area = ARGV[0]
location = ARGV[1]

time_data = fetch_time_in_timezone(area, location)

if time_data
  display_time_in_timezone(time_data)
end
