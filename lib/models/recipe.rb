class Recipe < ActiveRecord::Base 
    has_many :users, through: :user_recipes
end