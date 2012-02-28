require "matrix"
require "set"

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

      self.changed = true
    end

    def ==(other)
      return false unless self.class == other.class

      variants == other.variants
    end

    alias_method :eql?, :==

    def hash
      variants.hash
    end

    protected

    attr_reader :ingredients

    def variants
      update_variants if changed      

      @variants
    end
    
    private

    attr_accessor :margins, :changed
    attr_writer :ingredients, :variants

    def update_variants
      if margins.values.any? { |e| e == Float::INFINITY }
        raise InvalidRecipeError
      end

      recipes = shifts.map do |x,y|
        recipe      = self.class.new

        ingredients.each do |position, content|
          new_position = position + Vector[x,y]

          recipe[*new_position] = content
        end

        Set[*recipe.ingredients]
      end

      self.variants = Set[*recipes]
      self.changed  = false
    end

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
