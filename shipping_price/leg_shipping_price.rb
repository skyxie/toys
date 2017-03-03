def allocate_price(legs, price)
  total = legs.inject(0) { |total, leg| total + leg['dist'] }
  perc = price.to_f/total

  total_price = 0
  legs.each do |leg|
    actual_price = leg['dist'] * perc
    leg['price'] = (actual_price * 100).floor / 100.0
    total_price += leg['price']
    leg['error'] = actual_price - leg['price']
  end

  return legs if total_price == price
  diff = (price - total_price).round(2) * 100

  legs = legs.sort_by { |leg| leg['error'] }.reverse

  (1..diff).each do |i|
    legs[i - 1]['price'] += 0.01
  end

  return legs
end