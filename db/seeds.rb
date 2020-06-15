User.destroy_all
Recipe.destroy_all
Ingredient.destroy_all
UserRecipe.destroy_all
RecipeIngredient.destroy_all


esther = User.find_or_create_by(name: 'Esther')
david = User.find_or_create_by(name: 'David')

pasta = Recipe.find_or_create_by(name: 'Pasta') 
bread = Recipe.find_or_create_by(name: 'Bread') 
cake = Recipe.find_or_create_by(name: 'Cake') 
sandwich = Recipe.find_or_create_by(name: 'Sandwich') 
gimbap = Recipe.find_or_create_by(name: 'Gimbap') 

userrecipe1 = UserRecipe.find_or_create_by(user_id: esther.id, recipe_id: pasta.id, rating: 4)
userrecipe2 = UserRecipe.find_or_create_by(user_id: esther.id, recipe_id: bread.id, rating: 5)
userrecipe3 = UserRecipe.find_or_create_by(user_id: esther.id, recipe_id: cake.id, rating: 3)
userrecipe4 = UserRecipe.find_or_create_by(user_id: david.id, recipe_id: pasta.id, rating: 5)
userrecipe5 = UserRecipe.find_or_create_by(user_id: david.id, recipe_id: sandwich.id, rating: 3)
userrecipe6 = UserRecipe.find_or_create_by(user_id: david.id, recipe_id: gimbap.id, rating: 1)


flour = Ingredient.find_or_create_by(name: 'Flour', calories: 50)
sugar = Ingredient.find_or_create_by(name: 'Sugar', calories: 100)
rice = Ingredient.find_or_create_by(name: 'Rice', calories: 65)
water = Ingredient.find_or_create_by(name: 'Water', calories: 0)
yeast = Ingredient.find_or_create_by(name: 'Yeast', calories: 30)
seaweed = Ingredient.find_or_create_by(name: 'Seaweed', calories: 15)

recipeingredient1 = RecipeIngredient.find_or_create_by(recipe_id: pasta.id, ingredient_id: flour.id)
recipeingredient2 = RecipeIngredient.find_or_create_by(recipe_id: pasta.id, ingredient_id: water.id)
recipeingredient3 = RecipeIngredient.find_or_create_by(recipe_id: pasta.id, ingredient_id: yeast.id)
recipeingredient4 = RecipeIngredient.find_or_create_by(recipe_id: bread.id, ingredient_id: flour.id)
recipeingredient5 = RecipeIngredient.find_or_create_by(recipe_id: bread.id, ingredient_id: water.id)
recipeingredient6 = RecipeIngredient.find_or_create_by(recipe_id: bread.id, ingredient_id: sugar.id)
recipeingredient7 = RecipeIngredient.find_or_create_by(recipe_id: cake.id, ingredient_id: flour.id)
recipeingredient8 = RecipeIngredient.find_or_create_by(recipe_id: cake.id, ingredient_id: sugar.id)
recipeingredient9 = RecipeIngredient.find_or_create_by(recipe_id: sandwich.id, ingredient_id: flour.id)
recipeingredient10 = RecipeIngredient.find_or_create_by(recipe_id: sandwich.id, ingredient_id: rice.id)
recipeingredient11 = RecipeIngredient.find_or_create_by(recipe_id: gimbap.id, ingredient_id: rice.id)
recipeingredient12 = RecipeIngredient.find_or_create_by(recipe_id: gimbap.id, ingredient_id: seaweed.id)
