module CraftingTable
  class Cookbook
    def initialize
      self.recipes = {}
    end

    def [](recipe)
      variant = recipe.variants.find { |v| recipes[v] }

      recipes[variant] if variant
    end

    def []=(recipe, output)
      if recipe.variants.any? { |x| recipes[x] }
        raise ArgumentError, "A variant of this recipe is already defined!"
      end

      recipes[recipe] = output
    end

    private

    attr_accessor :recipes
  end
end
