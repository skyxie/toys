
require 'uri'
require 'json'

describe 'Server', type: :request do
  let(:request_body) do
    JSON.dump({
      'price' => price,
      'segments' => distances.map { |dist| {dist: dist} }
    })
  end

  let(:uri) { URI('http://localhost:4567/') }

  let(:parsed_response) do
    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new(uri, {'Content-Type' => 'application/json'})
      req.body = request_body
      resp = http.request(req)
      JSON.parse(resp.body)
    end
  end

  let(:allocated_prices) do
    parsed_response['segments'].map do |seg|
      seg['price']
    end
  end

  let(:allocated_total_price) do
    allocated_prices.reduce(0) do |total, price|
      total + price
    end
  end

  let(:price) { 10.0 }

  shared_examples 'correct' do
    it 'should have 2 decimals in each price' do
      allocated_prices.each do |allocated_price|
        expect(allocated_price.to_s).to match(/\.[0-9]{1,2}$/)
      end
    end

    it 'should sum to the total' do
      expect(Float(sprintf("%2g", allocated_total_price))).to eq(price)
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
    let(:price) { 1 }
    let(:distances) { 200.times.map{ 1 } }
    it_behaves_like 'correct'
  end
end

