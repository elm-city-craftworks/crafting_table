module CraftingTable
  Importer = Object.new

  class << Importer
    def cookbook_from_csv(filename)
      cookbook = Cookbook.new

      File.open(filename) do |f|
        csv = CSV.new(f)

        until f.eof?
          product, quantity = csv.gets

          grid = [csv.gets, csv.gets, csv.gets]

          cookbook[recipe_from_grid(grid)] = [product, quantity]

          csv.gets
        end
      end

      cookbook
    end

    def recipe_from_grid(grid)
      recipe = Recipe.new

      last_row = Recipe::TABLE_WIDTH  - 1
      last_col = Recipe::TABLE_HEIGHT - 1

      ((0..last_row).to_a).product((0..last_col).to_a) do |x,y|
        row = x
        col = last_col - y
        
        next if grid[col][x] =~ /-/

        recipe[x,y] = grid[col][x]
      end

      recipe
    end
  end
end
