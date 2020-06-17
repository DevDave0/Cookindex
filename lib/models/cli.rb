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
            if User.exists?(:name => user_name)
                $user = User.find_by(name: user_name)
                puts Rainbow("Welcome back, #{$user.name}!").coral
            else
                puts Rainbow("We could not find your username").red
                add_new_user
            end
        else
            add_new_user
        end
    end


    def menu
        puts Rainbow("
            ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
            ████╗ ████║██╔════╝████╗  ██║██║   ██║
            ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
            ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
            ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
            ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ ").cyan
        puts "#{line_break}"
        puts Rainbow("Please select from the following options - using numbers (0-5) as your input: 
        0. Exit
        1. Search for a recipe by ingredient 
        2. View your favorite recipes 
        3. Delete a recipe from your favorites 
        4. View highest rated recipes 
        5. Delete a username").beige
        user_input = gets.chomp
            case user_input 
            when "0"
                puts Rainbow("
                    Happy Eating!
                    ").salmon
                exit 
            when "1" 
                find_recipe_by_ingredient
            when "2"
                favorite_recipes
            when "3"
                delete_recipe
            when "4" 
                highest_rated_recipe
            when "5"
                delete_account
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
            puts Rainbow("Hello, #{$user.name}!").lightcoral
        end

    end 

    def find_recipe_by_ingredient
        puts "Please enter ingredient name"
        user_input = gets.chomp

        # get_specific_recipe_from_api(user_input)

        if Ingredient.exists?(:name => user_input)
            ing_id = Ingredient.find_by(:name => user_input)
            result = RecipeIngredient.all.select{|ri| ri.ingredient_id == ing_id.id}
            new_result = result.map{|ri| ri.recipe_id}
            all_results = new_result.map do |id|
                recipe = Recipe.find(id)
                recipe.name
            end 

            recipe_names = [ ] 
            all_results.each_with_index do |recipe, i| 
                recipe_names << "#{i+1}. #{recipe}"
            end 

            puts "Here are some recipes that have #{user_input}."
            puts recipe_names 
            view_recipe
        else 
            puts Rainbow("
                Cannot find ingredient. Try something else!
                ").red 
            find_recipe_by_ingredient
        end 
    end 

    def view_recipe
        puts "Please enter the name of the recipe you would like to see."
        user_input = gets.chomp
        # add downcase when we get api info
        if Recipe.exists?(:name => user_input)
            recipe = Recipe.find_by(:name => user_input)
            puts recipe.name #and more info about the recipe
            puts "Would you like to save this recipe to your favorites? (yes/no) "
            user_input = gets.chomp.downcase
                if user_input == 'yes'
                    result = UserRecipe.all.select{|ur| ur.user_id == $user.id}
                    id_array = result.map{|ri| ri.recipe_id}
                    name_array = id_array.map do |id|
                        recipe_name = Recipe.find(id)
                        recipe_name.name
                    end
                    
                    if name_array.include?(recipe.name)
                        puts Rainbow("
                            This recipe is already in your favorites
                            ").red
                        menu
                    else 
                        puts "Please give this recipe a rating(0-10)"
                        input = gets.chomp 
                        UserRecipe.create(user_id: $user.id, recipe_id: recipe.id, rating: input.to_i)
                        puts Rainbow("Recipe saved!").cyan
                        menu
                    end
                    
                else
                    menu
                end
        else 
            puts Rainbow("
                Cannot find recipe. Try something else!
                ").red
            view_recipe 
        end
    end


    def favorite_recipes
        favorites = []
        result = UserRecipe.all.select{|ur| ur.user_id == $user.id}
        result.each_with_index do |ur, i|
            recipe = Recipe.find(ur.recipe_id)
            favorites << "#{i+1}. #{recipe.name}"
        end
        puts "Here are your favorite Recipes!"
        puts "#{line_break}"
        puts favorites
        view_recipe
        menu
    end

    def delete_recipe
        favorites = []
        result = UserRecipe.all.select{|ur| ur.user_id == $user.id}
        result.each_with_index do |ur, i|
            recipe = Recipe.find(ur.recipe_id)
            favorites << "#{i+1}. #{recipe.name}"
        end
        puts "Here are your favorite Recipes!"
        puts "#{line_break}"
        puts favorites
        puts "Please enter the name of the recipe you would like to delete."
        user_input = gets.chomp
        recipe_delete = Recipe.find_by(name: user_input)
        result.each do |ur|
            if ur.recipe_id == recipe_delete.id
                UserRecipe.all.delete(ur.id)
            end
        end 
        puts Rainbow(" 
            Recipe deleted!
            ").red
        menu
    end 

    def highest_rated_recipe
        favorites = []
        result = UserRecipe.order(rating: :desc)
        result.each do |ur|
            if ur.user_id == $user.id
                favorites << ur
            end
        end
        rated_recipes = [ ] 
        favorites.each do |ur|
            result = Recipe.find(ur.recipe_id).name
            rated_recipes << result 
        end

        neat_array = []
        rated_recipes.each_with_index do |recipe, i|
            neat_array << "#{i+1}. #{rated_recipes[i]}"
        end 

        puts "Here are your highest rated recipes!"
        puts "#{line_break}"
        puts neat_array

        view_recipe
        
        menu

    end

    def delete_account
        result = User.all.map{|user| user.id}
        puts all_users
        puts "Please enter the username you would like to delete."
        user_input = gets.chomp
        username_delete = User.find_by(name: user_input)
        result.each do |user|
            if user == username_delete.id
                User.all.delete(user)
                puts Rainbow("
                    Username deleted!
                    ").red
            end
        end 
        menu
    end

    def all_users
        all_users = []
        result = User.all
        result.each_with_index do |user, i|
            all_users << "#{i+1}. #{user.name}"
        end
        all_users
    end

    # helper methods

    def line_break
        return "--------------------------------------------------------------------------------"
    end

    def practice
        binding.pry
    end

end