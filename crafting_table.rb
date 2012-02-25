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
    positions = data.map { |e| e[0] }

    candidates(positions).map do |x,y|
      ingredients = data.map { |e|
        position, content = e
        new_position = position + Vector[x,y]

        [new_position, content]
      }

      IngredientList.new(Set[*ingredients])
    end
  end

  def candidates(set)
    x_values = set.map { |e| e[0] }
    y_values = set.map { |e| e[1] }

    valid_shifts(x_values).product(valid_shifts(y_values))
  end

  def valid_shifts(values)
    (-2..2).each_with_object([]) do |offset, valid_offsets|
      c = values.map { |e| e + offset }
       
      valid_offsets << offset unless c.min < 0 || c.max > 2 
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

user_input  = IngredientList.new(Set[[Vector[0,2], :plank],
                                     [Vector[1,2], :plank],
                                     [Vector[1,1], :stick],
                                     [Vector[1,0], :stick]])



cookbook = { recipe_input => recipe_output }

user_input.mutations.each do |input|
  if match=cookbook[input]
    p match
    break 
  end
end

p Time.now - t
