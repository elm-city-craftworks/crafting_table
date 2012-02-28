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

      self.variants_need_updating = true
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
      update_variants if variants_need_updating

      @variants
    end
    
    private

    attr_accessor :margins, :ingredients, :variants_need_updating
    attr_writer :variants

    def update_variants
      if margins.values.any? { |e| e == Float::INFINITY }
        raise InvalidRecipeError
      end

      variant_hashes = valid_offsets.map do |x,y|
        ingredients.each_with_object({}) do |(position, content), var|
          new_position = position + Vector[x,y]

          var[new_position] = content
        end
      end

      self.variants                  = Set[*variant_hashes]
      self.variants_need_updating    = false
    end

    def update_margins(x,y)
      margins[:left]   = [x,                margins[:left]  ].min
      margins[:right]  = [TABLE_WIDTH-x-1,  margins[:right] ].min
      margins[:bottom] = [y,                margins[:bottom]].min
      margins[:top]    = [TABLE_HEIGHT-y-1, margins[:top]   ].min
    end

    def valid_offsets
      horizontal = (-margins[:left]..margins[:right]).to_a
      vertical   = (-margins[:bottom]..margins[:top]).to_a

      horizontal.product(vertical)
    end
  end
end
