require 'active_support/core_ext/class/attribute'

class Polygon
  class_attribute :sides
end

class Triangle < Polygon
end

Polygon.sides = 8
Triangle.sides = 3

puts Polygon.sides, Triangle.sides  # => 8, 3
