The JSON gems allows instantiating an object instead of a Hash from a JSON string as documented [here](http://flori.github.io/json/), but it appears that depending on how you decode a JSON string, whether or not object instantiation happens varies.

Use Gemfile to ensure the correct ruby and json gem versions

## ruby-1.8.7-p374

### Example run

    $ bundle exec ruby /tmp/test_json.rb 
    JSON gem version=1.5.4
    {"b"=>{"a"=>1, "b"=>2}, "a"=>Hey, I'm an object! a=1 b=2}
    $ ruby /tmp/test_json.rb parse
    JSON gem version=1.5.4
    {"b"=>{"a"=>1, "b"=>2}, "a"=>Hey, I'm an object! a=1 b=2}

### Results

json version | JSON.load | JSON.parse
-------------|-----------|------------
1.5.4 | `{"b"=>{"a"=>1, "b"=>2}, "a"=>Hey, I'm an object! a=1 b=2}` | `{"b"=>{"a"=>1, "b"=>2}, "a"=>Hey, I'm an object! a=1 b=2}`
1.5.5 | `{"b"=>{"a"=>1, "b"=>2}, "a"=>{"json_class"=>"A", "a"=>1, "b"=>2}}` | `{"b"=>{"a"=>1, "b"=>2}, "a"=>{"a"=>1, "b"=>2, "json_class"=>"A"}}`
1.7.7 | `{"b"=>{"a"=>1, "b"=>2}, "a"=>Hey, I'm an object! a=1 b=2}` | `{"b"=>{"a"=>1, "b"=>2}, "a"=>{"json_class"=>"A", "a"=>1, "b"=>2}}`

## ruby-2.0.0-p353

### Example run

    $ bundle exec ruby test_json.rb 
    JSON gem version=1.7.7
    {"b"=>{"a"=>1, "b"=>2}, "a"=>Hey, I'm an object! a=1 b=2}
    $ bundle exec ruby test_json.rb parse
    JSON gem version=1.7.7
    {"b"=>{"a"=>1, "b"=>2}, "a"=>{"json_class"=>"A", "a"=>1, "b"=>2}}

### Results

json version | JSON.load | JSON.parse
-------------|-----------|------------
1.5.4 | `{"b"=>{"a"=>1, "b"=>2}, "a"=>{"json_class"=>"A", "a"=>1, "b"=>2}}` | `{"b"=>{"a"=>1, "b"=>2}, "a"=>{"json_class"=>"A", "a"=>1, "b"=>2}}`
1.5.5 | `{"b"=>{"a"=>1, "b"=>2}, "a"=>{"json_class"=>"A", "a"=>1, "b"=>2}}` | `{"b"=>{"a"=>1, "b"=>2}, "a"=>{"json_class"=>"A", "a"=>1, "b"=>2}}`
1.7.7 | `{"b"=>{"a"=>1, "b"=>2}, "a"=>Hey, I'm an object! a=1 b=2}` | `{"b"=>{"a"=>1, "b"=>2}, "a"=>{"json_class"=>"A", "a"=>1, "b"=>2}}`