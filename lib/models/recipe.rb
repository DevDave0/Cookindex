class Recipe < ActiveRecord::Base 
    has_many :users, through :recipe_ingredients
end