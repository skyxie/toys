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
