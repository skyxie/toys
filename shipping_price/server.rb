#! /usr/bin/env ruby

require 'json'
require 'sinatra'
require 'rack/parser'
require './leg_shipping_price'

use Rack::Parser, parsers: {'application/json' => -> (data) { JSON.parse(data) }}

get '/' do
  begin
    price = params['price']
    allocated_segments = allocate_price(params['segments'], price)
    result = {'segments' => allocated_segments, 'price' => price}
    [200, JSON.dump(result)]
  rescue Exception => e
    [400, "Bad Request: #{params.to_json}"]
  end
end
