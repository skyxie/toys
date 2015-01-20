JSON auto-object-instantiation and why it sucks
================

"JSON auto-object-instantiation" is a term I made up to describe a particular feature in the ruby JSON library. I made it up because the feature doesn't really have a name, but I had to call it something for this blog post! I would hope that the name is self-explanatory for anybody familiar with the feature, but in case you're not familiar (or if the name just sucks) here's an explanation:

### What is it?

Parsing JSON text generally returns a hash-like key-value object. This is more or less expected in every language, especially the origin and namesake of JSON - Javascript. However, the official JSON implementation for ruby included in the standard library includes [documentation to define any arbitrary ruby class as a JSON type](http://flori.github.io/json/). Parsing JSON text with a defined "json_class" returns an instance of that ruby class.

For example, suppose you have a class A that has implemented this JSON type. Given an object of class A, it can be serialized to JSON text and then that JSON can be deserialized back into an object of class A.

To drive home how this works and it's implications, here's a very simple code illustration. First, I've written a class A that defines a JSON type. I've added a `to_s` method so that an object of class A will print out a very specific string, identifying itself as an object of class A and displaying its contents.

````ruby
class A
  def initialize a, b
   @a = a
   @b = b
  end

  def to_json(*args)
    {'json_class' => self.class.name, 'a' => @a, 'b' => @b}.to_json(args)
  end

  def self.json_create(o)
    new(o['a'], o['b'])
  end

  def to_s
    "Hey, I'm an object! a=#{@a} b=#{@b}"
  end
  alias :inspect :to_s
end
````

Second, here is some code that serializes and deserializes an object of class A and prints all of it's contents.

````ruby
obj = A.new(1, 2)
serialized = JSON.generate(obj)
deserialized = JSON.load(serialized)

puts "obj=#{obj}"
puts "serialized=#{serialized}"
puts "deserialized=#{deserialized}"
````

When we run this code we get the following output:

    obj=Hey, I'm an object! a=1 b=2
    serialized={"json_class":"A","b":2,"a":1}
    deserialized=Hey, I'm an object! a=1 b=2

which is great! This shows that we created an object of class A, serialized it to JSON, and deserialized the JSON text back into an object of class A.

Not only does this work at the top level of JSON text, but it actually works recursively. An object defined at any depth in the JSON text will be automatically instantiated. Slightly changing our earlier code for serializing and deserializing an object:

````ruby
obj = {"a" => A.new(1, 2), "b" => [A.new(3, 4)]}
serialized = JSON.generate(obj)
deserialized = JSON.load(serialized)

puts "obj=#{obj.inspect}"
puts "serialized=#{serialized}"
puts "deserialized=#{deserialized.inspect}"
````

we get the following result:

    obj={"b"=>[Hey, I'm an object! a=3 b=4], "a"=>Hey, I'm an object! a=1 b=2}
    serialized={"b":[{"b":4,"a":3,"json_class":"A"}],"a":{"b":2,"a":1,"json_class":"A"}}
    deserialized={"a"=>Hey, I'm an object! a=1 b=2, "b"=>[Hey, I'm an object! a=3 b=4]}

At first, this might sound very handy. There's no need to map JSON text to an object nor any need to build assumptions or validations into what type of JSON text to expect because the JSON library takes care of everything for you. Upon parsing the text, you can immediately start working with an object. At the very worst, it might just seem like mostly harmless syntatic sugar to make development.

But actually, it sucks. Here's why ...

### Inconsistent Implemetation

Code is not written in stone. In fact, most of the time, it's more like it's written in plaster. Code changes a lot. Backwards compatibility is a persistent challenge. Dependence on unstable libraries can lead to your foundation collapsing beneath you.

Let's see how the ruby JSON library has changed over time. To do this, I will be using this snippet of code:

````ruby
puts "ruby version=#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
spec = Gem::Specification.find_by_name("json")
puts "JSON gem version=#{spec.version}"

obj = A.new(1, 2)
serialized = JSON.generate(obj)
deserialized_with_parse = JSON.parse(serialized)
deserialized_with_load = JSON.load(serialized)

puts "obj=#{obj}"
puts "serialized=#{serialized}"
puts "deserialized_with_parse=#{deserialized_with_parse.inspect}"
puts "deserialized_with_load=#{deserialized_with_load.inspect}"
````

The 1st section of this snippet prints the ruby version, patchlevel, and json gem version. I will be controlling for the ruby and gem version using bundler. The rest should look very familiar, except that this snippet will display the result of two different methods for parsing JSON: `parse` vs `load`.

Let's start with a _very old_ version of ruby version and a _very old_ version of the JSON gem:

    ruby version=1.8.7-p374
    JSON gem version=1.5.4
    obj=Hey, I'm an object! a=1 b=2
    serialized={"b":2,"a":1,"json_class":"A"}
    deserialized_with_parse=Hey, I'm an object! a=1 b=2
    deserialized_with_load=Hey, I'm an object! a=1 b=2

Everything looks great, exactly how we would expect it to look!

Let's try slightly bumping up the JSON gem version.

    ruby version=1.8.7-p374
    JSON gem version=1.5.5
    obj=Hey, I'm an object! a=1 b=2
    serialized={"b":2,"a":1,"json_class":"A"}
    deserialized_with_parse={"a"=>1, "b"=>2, "json_class"=>"A"}
    deserialized_with_load={"a"=>1, "b"=>2, "json_class"=>"A"}

Now nothing works. :(

Maybe things look better on a modern version of the gem, let's bump it up to the latest version available at the time of writing 1.8.2:

    ruby version=1.8.7-p374
    JSON gem version=1.8.2
    obj=Hey, I'm an object! a=1 b=2
    serialized={"b":2,"a":1,"json_class":"A"}
    deserialized_with_parse={"a"=>1, "b"=>2, "json_class"=>"A"}
    deserialized_with_load=Hey, I'm an object! a=1 b=2

Now `load` will automatically instantiate the object, but `parse` will not. I suppose that's better than nothing?

It's not so surprising that the behavior of the JSON library should change when we change the gem version, but surely changing the ruby version should have no effect on the behavior on the JSON gem. Let's try using the same gem versions on a higher version of ruby.

    ruby version=2.0.0-p353
    JSON gem version=1.5.5
    obj=Hey, I'm an object! a=1 b=2
    serialized={"json_class":"A","a":1,"b":2}
    deserialized_with_parse={"json_class"=>"A", "a"=>1, "b"=>2}
    deserialized_with_load={"json_class"=>"A", "a"=>1, "b"=>2}

    ruby version=2.0.0-p353
    JSON gem version=1.8.2
    obj=Hey, I'm an object! a=1 b=2
    serialized={"json_class":"A","a":1,"b":2}
    deserialized_with_parse={"json_class"=>"A", "a"=>1, "b"=>2}
    deserialized_with_load=Hey, I'm an object! a=1 b=2

Even though the behavior of the JSON gem is not consistent between versions 1.5.4, 1.5.5 and 1.8.2, at least the behavior for gem version 1.5.5 and 1.8.2 is consistent between ruby-1.8.7-p374 and ruby-2.0.0-p353. What about JSON gem version 1.5.4?

    ruby version=2.0.0-p353
    JSON gem version=1.5.4
    obj=Hey, I'm an object! a=1 b=2
    serialized={"json_class":"A","a":1,"b":2}
    deserialized_with_parse={"json_class"=>"A", "a"=>1, "b"=>2}
    deserialized_with_load={"json_class"=>"A", "a"=>1, "b"=>2}

Looks like JSON gem version 1.5.4 completely breaks between ruby-1.8.7-p374 and ruby-2.0.0-p353 ... :(

This might look like picking at details, but JSON is core library. How many other gems are built on top of JSON? MultiJson and resque are just two major examples that come to mind. Earlier versions of resque actually use JSON.parse, while later versions use JSON.load. Any code that's dependent on this behavior would not only be subject to changes in JSON, but also changes to how other gems use JSON.

### A mine waiting to go off

Clearly, the behavior of this feature in the ruby JSON library can change a lot. That's a good reason not to use it, but technically, that's just a flaw in the implementation or documentation of JSON in ruby. That does not necessarily make JSON auto-object-instantiation a bad idea in principle.

But actually, it is a terrible idea. It's a hidden mine waiting to be tripped.

Consider the consequences if we wanted to change the class A that has been used as an example? Suppose we want to add a 3rd optional argument that's an object of a new class B? In that case, the JSON text should look like:

````json
{
  "json_class": "A",
  "a": 1,
  "b": 2,
  "optional": {
    "json_class": "B",
    "data": 2
  }
}
````

The 3rd "optional" argument is as it's named - optional. It could refer to a new feature that we do not need to consume yet. In fact, class B hasn't even been written yet so we wouldn't even know what to do with the new optional argument. This is a purely additive change to the JSON text consumed earlier so it's reasonable to assume that it shouldn't break the existing code. However, attempting to parse this JSON is actually broken. It will actually raise an exception with the message: `ArgumentError: can't get const B: uninitialized constant B`.

The JSON library recursively parses the text and attempts to instantiate an object for the non-existent class B. I mentioned earlier that JSON auto-object-instantiation might seem like a good idea at first because it allows the developer to forget making any assumptions or validations of the JSON text, but it actually inherently has a *HUGE* assumption built-in: that the code generating the JSON text is the same as the code consuming the JSON.

JSON is frequently used in practical applications as a data format to efficiently transport simple data from a generator to a consumer. This data passing can occur over HTTP requests, a message queue (like resque), a cache-layer between multiple server instances and machines, etc. In all of these cases, the code in the generator is not necessarily identical to the consumer! Even in the example of a cache-layer, which would be the same code everywhere most of the time, during a deployment, one instance or machine will be deployed ahead of others (unless you take your entire service down). One such instance could write an object to the cache that's unparsable to other instances.

JSON auto-object-instantiation makes the JSON consumer heavily dependent on the generator. The JSON generator could effectively crash the consumer with just a small message change.

### Why does any of this matter?

At Animoto, many years ago, we widely implemented a system that used JSON auto-object instantiation. Since then we repeatedly built on top of the existing system and shortly forgot about the underlying assumptions in JSON auto-object instantiation. Eventually, we started running into all sorts of problems whenever we tried to upgrade our JSON gem or even libraries that used JSON. Now, we just want to prevent anyone else from haplessly wandering into the same quagmire we did.
