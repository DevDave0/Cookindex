require 'rainbow'
require 'pry'


class CommandLine

    def welcome
        puts Rainbow('
        ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗███╗   ██╗██████╗ ███████╗██╗  ██╗
       ██╔════╝██╔═══██╗██╔═══██╗██║ ██╔╝██║████╗  ██║██╔══██╗██╔════╝╚██╗██╔╝
       ██║     ██║   ██║██║   ██║█████╔╝ ██║██╔██╗ ██║██║  ██║█████╗   ╚███╔╝ 
       ██║     ██║   ██║██║   ██║██╔═██╗ ██║██║╚██╗██║██║  ██║██╔══╝   ██╔██╗ 
       ╚██████╗╚██████╔╝╚██████╔╝██║  ██╗██║██║ ╚████║██████╔╝███████╗██╔╝ ██╗
        ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝
        ').aqua
    puts Rainbow('               The Command Line Program to save your favorite recipes.').cyan.bright
    puts '                         Do you have an account?(yes/no)'

    user_input = gets.chomp.downcase

        if user_input == 'yes'
            puts "What is your username?"
            user_name = gets.chomp.downcase
            # if User.all.include?(name: user_name)
            # $user = user_name
            # puts "Welcome back"
            
            if User.exists?(:name => user_name)
                $user = User.find_by(name: user_name)
                puts "Welcome back #{$user.name}"
            else
                puts "We could not find your username"
                add_new_user
            end
        else
            puts "Please create a new account."
            add_new_user
        end
    end


    def menu
        puts "#{line_break}
        Please select from the following options - using numbers (0-5) as your input: 
        0. Exit
        1. Search for a recipe by ingredient 
        2. View your favorite recipes 
        3. View healthy recipes 
        4. View highest rated recipes 
        5. Delete a recipe from your favorites"
        user_input = gets.chomp
            case user_input 
            when "1" 
                # runs search for recipe by ingredient method
                find_recipe_by_ingredient
            when "2"
                # returns all fave recipes
                puts "faves"
            when "3"
                # returns all healthy recipes
                puts "i'm healthy"
            when "4" 
                # returns highest rated recipes 
                puts "i'm popular"
            when "5"
                # removes a recipe from favorites
                puts "bye"
            else 
                puts "Invalid entry."
                menu
            end 
    end


    def add_new_user
        puts "Please enter a new username:"
        user_name = gets.chomp.downcase
        if User.exists?(:name => user_name)
            puts "Username is taken, please try again"
            add_new_user
        else
            new_user = User.create(name: user_name)
            $user = new_user
            puts "Welcome back #{$user.name}"
        end

    end 

    def find_recipe_by_ingredient
        puts "Please enter ingredient or recipe name"
        user_input = gets.chomp

        if Ingredient.exists?(:name => user_input)
            ing_id = Ingredient.find_by(:name => user_input)
            
            result = RecipeIngredient.all.select do |ri|
                ri.ingredient_id == ing_id.id
            end 
            new_result = result.map do |ri|
                ri.recipe_id 
            end
            all_results = new_result.map do |id|
                recipe = Recipe.find(id)
                recipe.name
            end 
    
            recipe_names = [ ] 
            all_results.each_with_index do |recipe, i| 
                recipe_names << "#{i+1}. #{recipe}"
            end 
            puts recipe_names 
        else 
            puts "Cannot find ingredient. Try something else!" 
            find_recipe_by_ingredient
        end 
    end 

    # helper methods

    def line_break
        return "--------------------------------------------------------------------------------------------"
    end



end