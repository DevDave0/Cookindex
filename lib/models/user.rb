class User < ActiveRecord::Base 
    has_many :recipes, through: :recipe_ingredients

end