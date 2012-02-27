require "matrix"

module CraftingTable
  InvalidRecipeError = Class.new(StandardError)

  class Recipe
    TABLE_WIDTH  = 3
    TABLE_HEIGHT = 3

    def initialize
      self.ingredients = {}
      self.margins     = { :top    => Float::INFINITY, 
                           :left   => Float::INFINITY, 
                           :right  => Float::INFINITY,
                           :bottom => Float::INFINITY }
    end
    
    def [](x,y)
      raise ArgumentError unless (0...TABLE_WIDTH).include?(x)
      raise ArgumentError unless (0...TABLE_HEIGHT).include?(y)

      ingredients[Vector[x,y]]
    end

    def []=(x,y,ingredient_type)
      raise ArgumentError unless (0...TABLE_WIDTH).include?(x)
      raise ArgumentError unless (0...TABLE_HEIGHT).include?(y)

      update_margins(x,y)

      ingredients[Vector[x,y]] = ingredient_type
    end

    def positions
      ingredients.keys
    end

    # supports horizontal and vertical shifting, but not horizontal flips.
    #
    def variants
      if margins.values.any? { |e| e == Float::INFINITY }
        raise InvalidRecipeError
      end

      shifts.map do |x,y|
        recipe      = self.class.new

        ingredients.each do |position, content|
          new_position = position + Vector[x,y]

          recipe[*new_position] = content
        end

        recipe
      end
    end

    def ==(other)
      return false unless self.class == other.class

      variants.any? { |e| e.ingredients == other.ingredients }
    end

    alias_method :eql?, :==

    def hash
      ingredients.hash
    end

    protected

    attr_accessor :ingredients

    private

    attr_accessor :margins

    def update_margins(x,y)
      margins[:left]   = [x,                margins[:left]  ].min
      margins[:right]  = [TABLE_WIDTH-x-1,  margins[:right] ].min
      margins[:bottom] = [y,                margins[:bottom]].min
      margins[:top]    = [TABLE_HEIGHT-y-1, margins[:top]   ].min
    end

    def shifts
      horizontal = (-margins[:left]..margins[:right]).to_a
      vertical   = (-margins[:bottom]..margins[:top]).to_a

      horizontal.product(vertical)
    end
  end
end
