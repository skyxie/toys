
require 'uri'
require 'json'

HOSTNAME = 'localhost'
PORT = 8080

describe 'Server', type: :request do
  let(:request_params)  do
    {
      'total_price' => price,
      'currency' => 'USD',
      'segments' => distances.map do |dist|
        {'distance' => dist}
      end
    }
  end

  let(:create_response) do
    uri = URI("http://#{HOSTNAME}:#{PORT}/shipments")

    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Post.new(uri, {'Content-Type' => 'application/json'})
      req.body = JSON.dump(request_params)
      http.request(req)
    end
  end

  let(:get_response) do
    id = parsed_create_response["id"]
    uri = URI("http://#{HOSTNAME}:#{PORT}/shipments/#{id}")
    Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(Net::HTTP::Get.new(uri, {'Content-Type' => 'application/json'}))
    end
  end

  def response_parser(response)
    parsed = JSON.parse(response.body)
    parsed['total_price'] = Float(parsed['total_price'])
    parsed['segments'].each do |segment|
      segment['distance'] = Float(segment['distance'])
    end
    parsed
  end

  let(:parsed_create_response) { response_parser(create_response) }
  let(:parsed_get_response) { response_parser(get_response) }

  let(:allocated_prices) do
    parsed_get_response['segments'].map do |seg|
      Float(seg['price'])
    end
  end

  let(:allocated_total_price) do
    allocated_prices.reduce(0) do |total, price|
      total + price
    end
  end

  let(:price) { '100.00' }
  let(:distances) { [100.0] }

  it 'should not create shipment without total_price' do
    request_params.delete('total_price')
    expect(create_response.code).to_not eq(200)
  end

  it 'should not create shipment without segments' do
    request_params.delete('segments')
    expect(create_response.code).to_not eq(200)
  end

  it 'should not create shipment when segments are missing distances' do
    request_params['segments'][0].delete('distance')
    expect(create_response.code).to_not eq(200)
  end

  shared_examples 'correct' do
    it 'should have 2 decimals in each price' do
      allocated_prices.each do |allocated_price|
        expect(allocated_price.to_s).to match(/\.[0-9]{1,2}$/)
      end
    end

    it 'should sum to the total' do
      expect(Float(sprintf("%2g", allocated_total_price))).to eq(Float(price))
    end
  end

  describe 'distances add to 100' do
    let(:distances) { [70, 20, 10] }
    it_behaves_like 'correct'
  end

  describe 'distances add to 90' do
    let(:distances) { [60, 20, 10] }
    it_behaves_like 'correct'
  end

  describe 'equal distances add to 90' do
    let(:distances) { [30, 30, 30] }
    it_behaves_like 'correct'
  end

  describe '200 distances of 1' do
    let(:price) { '1.00' }
    let(:distances) { 200.times.map{ 1 } }
    it_behaves_like 'correct'
  end
end

