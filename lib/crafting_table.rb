require "csv"
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

    x_min = -(x_values.min)
    x_max = 2 - x_values.max

    y_min = -(y_values.min)
    y_max = 2 - y_values.max

    ((x_min..x_max).to_a).product((y_min..y_max).to_a)
  end

  protected

  attr_accessor :data
end

cookbook = {}

File.open("#{File.dirname(__FILE__)}/../data/basic_recipes.csv") do |f|
  csv = CSV.new(f)

  until f.eof?
    product, quantity = csv.gets

    grid = [csv.gets, csv.gets, csv.gets]

    ingredients = [0,1,2].product([0,1,2]).map { |x,y|
      next if grid[2-y][x] =~ /-/

      [Vector[x,y], grid[2-y][x]]
    }.compact

    cookbook[IngredientList.new(Set[*ingredients])] = [product, quantity]

    csv.gets
  end
end

user_input  = IngredientList.new(Set[[Vector[1,1], "wooden_plank"],
                                     [Vector[1,2], "wooden_plank"],
                                     [Vector[2,1], "wooden_plank"],
                                     [Vector[2,2], "wooden_plank"]])
                                      

user_input.mutations.each do |input|
  if match=cookbook[input]
    p match
    break 
  end
end
