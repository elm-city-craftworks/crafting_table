module CraftingTable
  InvalidRecipeError = Class.new(StandardError)

  class Recipe
    TABLE_WIDTH  = 3
    TABLE_HEIGHT = 3

    def initialize
      self.ingredients     = {}
      self.offset          = [Float::INFINITY, Float::INFINITY]
      self.normalized      = {}
    end

    def [](x,y)
      raise ArgumentError unless (0...TABLE_WIDTH).include?(x)
      raise ArgumentError unless (0...TABLE_HEIGHT).include?(y)

      ingredients[[x,y]]
    end

    def []=(x,y,ingredient_type)
      raise ArgumentError unless (0...TABLE_WIDTH).include?(x)
      raise ArgumentError unless (0...TABLE_HEIGHT).include?(y)

      ingredients[[x,y]] = ingredient_type
       
      update_offsets(x,y)
    end

    def ==(other)
      return false unless self.class == other.class

      normalized == other.normalized
    end

    alias_method :eql?, :==

    def hash
      normalized.hash
    end

    protected

    attr_reader :ingredients

    def normalized
      normalize if needs_normalization

      @normalized
    end

    private

    attr_accessor :offset, :needs_normalization
    attr_writer   :ingredients, :normalized

    def normalize
      self.normalized = {}

      ingredients.each do |pos, item| 
        new_pos = [pos[0] - offset[0], pos[1] + offset[1]]

        @normalized[new_pos] = item
      end

      self.needs_normalization = false
    end

    def update_offsets(x,y)
      x_offset    = [x,                offset[0]].min
      y_offset    = [TABLE_HEIGHT-y-1, offset[1]].min

      self.offset = [x_offset, y_offset]

      self.needs_normalization = true
    end
  end
end
