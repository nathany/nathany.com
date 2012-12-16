class Polygon
  @@sides = 8

  def self.sides
    @@sides
  end
end

class Triangle < Polygon
  @@sides = 3
end

puts Polygon.sides  # => 3
