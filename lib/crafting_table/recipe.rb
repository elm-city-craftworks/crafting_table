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

      ingredients[Vector[x,y]] = ingredient_type

      update_margins(x,y)

      self.dirty = true
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

    def variants
      update_variants if dirty 

      @variants
    end
    
    private

    attr_accessor :margins, :ingredients, :dirty
    attr_writer :variants

    def update_variants
      if margins.values.any? { |e| e == Float::INFINITY }
        raise InvalidRecipeError
      end

      variant_sets = shifts.map do |x,y|
        ingredients_set = Set.new

        ingredients.each do |position, content|
          new_position = position + Vector[x,y]

          ingredients_set << [new_position, content]
        end

        ingredients_set
      end

      self.variants = Set[*variant_sets]
      self.dirty    = false
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
