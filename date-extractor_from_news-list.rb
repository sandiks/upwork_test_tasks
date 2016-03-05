=begin
Details
Attached is a dataset of news titles. Please extract any information showing a date from the variable LP. For example, in the following setence, find "April 8, 2002".
FOR IMMEDIATE RELEASE: April 8, 2002-Buckhorn has added four new containers to its Straight Wall System, creating additional options to maximize container space usage and increase efficiency.
Please return me a CSV dataset, with the variable news_id as well as the dates extracted from the variable LP. The dates should be the format "YYYYMMDD," e.g., 20020408.
In case years are missing in the dataset, please use "3000MMDD." In other words, assign year=3000 when it is missing. If a date is missing but year and month are available, then assign the date as YYDD00.
I need the data quickly, so let me kn
=end

require 'date'

MONTH_NAMES = %w[
  January
  February
  March
  April
  May
  June
  July
  August
  September
  October
  November
  December
]

def main
  fpath = "/home/kilk/Downloads/dates.csv"
  File.readlines(fpath)[0..1000].each do |line|

    res = parse_line(line)
    #p res if not res.nil?

  end
end

def parse_line(line)
  
  #return unless line.include?("Natick, MA, July 12, 2004-Cognex")

  arr =  line.encode('UTF-8', :invalid => :replace).split(" ")
  need_parse=false
  month_word = arr[i]

  for ind in 0..arr.size-1
    if MONTH_NAMES.any?{|mm| mm==month_word || mm[0..3]==month_word || mm[0..4]==month_word}
      #month_index = Date::MONTHNAMES.index(arr[ind])

      month = MONTH_NAMES.each_with_index.find{|mm| mm[0].index(month_word)!=nil} #if month_word=="Sept"
      month_index = month.last+1

      date = arr[ind+1].split(',')
      dd = date.first

      if date.first.to_i>31
        year = date.first.to_i
        dd="00"
        need_parse=true
      elsif date.size>1
        year = date.last
      else
        year = arr[ind+2].scan(/\d[4]/)[0] unless arr[ind+2].nil?
        year = "3000" unless year =~ /^\d[4]/
      end

      mm = month_index<10 ? "0#{month_index}" : month_index.to_s
      date_str = "#{year}_#{mm}_#{dd}"
      p "#{date_str} | #{month_word} #{arr[ind+1]} #{arr[ind+2]}" if need_parse

      return [date_str]
      #date_str = "#{month_word} #{dd}, #{year}"
      #return [DateTime.strptime(date_str,"%B %e, %Y"),date_str]

    end

  end
  return nil
end
main
