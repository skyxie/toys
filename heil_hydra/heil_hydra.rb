#! /usr/bin/env ruby

require 'optparse'
require 'typhoeus'

options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: heil_hydra.rb --url <url> --timeouts <timeouts>"

  parser.on("--url url", "Url for request") do |url|
    options[:url] = url
  end

  parser.on("--timeouts t1,t2,t3", Array, "Timeout for each request") do |string_timeouts|
    options[:timeouts] = string_timeouts.map do |timeout|
      begin
        Integer(timeout)
      rescue ArgumentError
        puts "Invalid timeout #{timeout}"
        puts parser
        exit 1
      end
    end
  end
end.parse!

begin
  hydra = Typhoeus::Hydra.new

  options[:timeouts].each_with_index do |timeout, i|
    request = Typhoeus::Request.new(options[:url], timeout: timeout)

    request.on_complete do |response|
      puts "#{i}) timeout=#{timeout} status=#{response.code} | #{response.body}"
    end

    hydra.queue(request)
  end

  hydra.run
rescue Exception => e
  puts "EXCEPTION[#{e.class.name}] - #{e.message}"
end

