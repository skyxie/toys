#! /usr/bin/env ruby

class Test
  @@var = "class variable defined in class"

  def initialize
    @var = "instance variable defined in initialize"
  end

  attr_reader :var

  def class_var
    @@var
  end

  def class_instance_var
    self.class.var
  end

  class << self
    attr_accessor :var

    @@var = "class class variable defined in class class"

    def class_var
      @@var
    end
  end
end

t = Test.new
Test.var = "class instance variable defined in script"

puts t.var
puts t.class_var
puts t.class_instance_var
puts Test.var
puts Test.class_var
