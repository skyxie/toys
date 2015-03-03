A Critique of Pure Rational
======

As children, we spend a lot of time thinking about fractions. Fractions are basically the first number type we learn about, right after learning to count. Eventually, we start working with calculators, which do not handle fractions very well, and suddenly we don't think about fractions at all. Instead we substitute decimal approximations for pure expressions, 0.333333333333333 for ⅓.

Now as grown-up (or not so grown-up) programmers, we have so many ways to express a number (int, float, double, etc.), but we still aren't thinking with fractions. Ruby gives us the `Rational` class, but there's not a lot we can do with it. Even if we wanted to work with `Rational`, how could we transport that data via JSON? Approximating `Rational` objects to float could lose data. Writing `Rational` as a `numerator/denominator` string, `[1,3]` array, or `{"numerator":1,"denominator":3}` object requires the recipient to expect it. It's possible to use JSON auto-object instantiation, but [I would not recommend it](http://tech.animoto.com/2015/02/11/json-auto-object-instantiation-and-why-it-sucks/).

If we run `#to_json` on a `Rational` number as it is, what should we expect? At Animoto, we actually run into fractions quite often, especially when working with display and aspect ratios in video. These ratios need to be preserved perfectly (i.e. 1.33333333 is not a suitable substitute for 4/3) and they tend not to convert to float well (e.g. 4/3, 16/9). Sometimes we need to perform math operations on these numbers and to do that, we might use the `Rational` class. Along the way, we've encountered some surprising problems.

What would you guess the follow code snippet outputs?

````language-ruby
require 'json'
require 'rational'

msg = { "aspect_ratio" => Rational(16,9) }

puts msg.to_json

require 'active_support/core_ext/object'

puts msg.to_json
````

Most people would confidently proclaim that it will be `{"aspect_ratio":"16/9"}` both times. In most cases, they would be right. However, on activesupport version < 4.1.0, the first output is the expected `{"aspect_ratio":"16/9"}`, but the second output is `{"aspect_ratio":16/9}` - the latter notably being *invalid JSON*.

Activesupport adds an [`#encode_json` method to Numeric, which just returns `#to_s`](http://www.rubydoc.info/gems/activesupport/4.0.13/Numeric:encode_json#). This works well for floating point and integer numbers because they are native types in javascript and should be written in JSON unescaped - `{"aspect_ratio":1234}` gets encoded as `{"aspect_ratio":1234}` and `{"aspect_ratio" => 1.234}` gets encoded as `{"aspect_ratio" => 1.234}`. The ruby `Rational` class also inherits from Numeric and `#to_s` outputs the natural fraction representation of a Rational number (e.g. `Rational(12, 34).to_s # => "12/34"`). However, there is no native javascript representation of Rational numbers so the unescaped string is just invalid JSON.

Seems like activesupport just forgot about fractions entirely!

This bug is fixed in activesupport version >= 4.1.0, but indirectly. Activesupport completely changed how it generated JSON, relying more on the native `JSON#generate`. Still looks like they haven't thought about fractions!