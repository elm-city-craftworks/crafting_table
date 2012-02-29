require_relative "lib/crafting_table"

recipe = CraftingTable::Recipe.new

recipe[0,0] = "B"
p recipe.send(:margins) #=> {:top=>2, :left=>0, :right=>2, :bottom=>0}

recipe[1,0] = "C"
p recipe.send(:margins) #=> {:top=>2, :left=>0, :right=>1, :bottom=>0} 

recipe[0,1] = "A"
p recipe.send(:margins) #=> {:top=>1, :left=>0, :right=>1, :bottom=>0} 


recipe_file = "#{File.dirname(__FILE__)}/data/basic_recipes.csv"
cookbook    = CraftingTable::Importer.cookbook_from_csv(recipe_file)

user_recipe_1 = CraftingTable::Recipe.new
user_recipe_2 = CraftingTable::Recipe.new

user_recipe_1[1,0] = "stick"
user_recipe_1[1,1] = "coal"

user_recipe_2[2,0] = "stick"
user_recipe_2[2,1] = "coal"

p cookbook[user_recipe_1]
p cookbook[user_recipe_2]

p user_recipe_1 == user_recipe_2
p user_recipe_1.hash 
p user_recipe_2.hash
