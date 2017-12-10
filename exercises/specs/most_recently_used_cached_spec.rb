require 'most_recently_used_cache'

describe MostRecentlyUsedCache do
  let(:cache) { MostRecentlyUsedCache.new(5) }

  before(:each) do
    %w{Boston NYC Philadelphia Pittsburgh DC Cleveland Chicago}.each_with_index do |city, i|
      cache.put(i, city)
    end
  end

  it 'should update recency on lookup' do
    expect(cache.head.value).to eql('Chicago')
    expect(cache.get(0)).to eql('Boston')
    expect(cache.head.value).to eql('Boston')
  end

  it 'should keep data until pruning' do
    expect(cache.get(0)).to eql('Boston')
    cache.prune
    expect(cache.get(1)).to be_nil
  end
end