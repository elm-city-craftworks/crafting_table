module CraftingTable
  class Cookbook
    def initialize
      self.recipes = {}
    end

    def [](recipe)
      recipes[recipe]
    end

    def []=(recipe, output)
      if recipes[recipe]
        raise ArgumentError, "A variant of this recipe is already defined!"
      end

      recipes[recipe] = output
    end

    private

    attr_accessor :recipes
  end
end
