require "csv"
require "matrix"
require "set"

require_relative "lib/crafting_table"

recipe_file = "#{File.dirname(__FILE__)}/data/basic_recipes.csv"
cookbook    = CraftingTable::Importer.cookbook_from_csv(recipe_file)

user_recipe = CraftingTable::Recipe.new

user_recipe[1,0] = "stick"
user_recipe[1,1] = "coal"

p cookbook[user_recipe]
