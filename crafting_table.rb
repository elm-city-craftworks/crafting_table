require "matrix"
require "set"

class IngredientList
  def initialize(data)
    self.data = data
  end
  
  def ==(other)
    self.class == other.class && data == other.data
  end

  alias_method :eql?, :==

  def hash
    data.hash
  end

  def mutations
    (-2..2).to_a.product((-2..2).to_a).map do |x,y|

      translated_ingredients = data.map { |e|
        position, content = e
        new_position = position + Vector[x,y]

        next if new_position.min < -2 || new_position.max > 2

        [new_position, content]
      }.compact

      IngredientList.new(Set[*translated_ingredients])
    end
  end

  protected

  attr_accessor :data
end

t = Time.now

recipe_input  = IngredientList.new(Set[[Vector[0,2], :plank],
                                      [Vector[1,2], :plank],
                                      [Vector[1,1], :stick],
                                      [Vector[1,0], :stick]])

# TODO: account for quantities
recipe_output = :hoe

user_input  = IngredientList.new(Set[[Vector[1,2], :plank],
                                     [Vector[2,2], :plank],
                                     [Vector[2,1], :stick],
                                     [Vector[2,0], :stick]])



cookbook = { recipe_input => recipe_output }

user_input.mutations.each do |input|
#  p input

  if match=cookbook[input]
    p match
    break 
  end
end

p Time.now - t
