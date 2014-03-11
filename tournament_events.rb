# encoding: utf-8

require 'nokogiri'
require 'open-uri'

XML_PATH = 'http://api.sport.yandex.ru/public/tournament_events.xml'
# XML_PATH = './tournament_events.xml'
# XML_PATH = './paralympic_tournament_events.xml'
CSV_PATH = 'sochi_tournament_events.csv'
events_array = []

doc = Nokogiri::XML(open(XML_PATH))
doc.css('event').each do |event|
  events_array << {
    title: event['event_title'],
    competition_id: event['competition_id'],
    event_id: event['id'],
    time: DateTime.parse(event.css('time').inner_text).strftime('%F %R')
  }
end

events_array.sort!{ |a,b| a[:time] <=> b[:time] }

File.open(CSV_PATH, 'w') do |file|
  line = "Date/time;Title;competition_id;event_id\n"
  file.write(line)
  events_array.each do |event|
    line = "#{event[:time]};#{event[:title]};#{event[:competition_id]};#{event[:event_id]}\n"
    file.write(line)
  end
end
