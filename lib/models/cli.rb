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
        puts Rainbow("Please select from the following options - using numbers (1-6) as your input: 
        1. Search for a recipe by ingredient 
        2. View your favorite recipes 
        3. Delete a recipe from your favorites 
        4. View your highest rated recipes 
        5. Delete account
        6. Exit").beige
        user_input = gets.chomp
            case user_input 
            when "6"
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
        user_input = gets.chomp.downcase
        api_array = get_specific_recipe_from_api(user_input)
        info_array = get_specific_recipe_from_api(user_input)

        if api_array == 0 
            puts Rainbow("
                Cannot find ingredient. Try something else!
                ").red 
            find_recipe_by_ingredient
        else 
        # if Ingredient.exists?(:name => user_input)
        #     ing_id = Ingredient.find_by(:name => user_input)
        #     result = RecipeIngredient.all.select{|ri| ri.ingredient_id == ing_id.id}
        #     new_result = result.map{|ri| ri.recipe_id}
        #     all_results = new_result.map do |id|
        #         recipe = Recipe.find(id)
        #         recipe.name
        #     end 

            recipe_names = [ ] 
            api_array.each_with_index do |recipe, i| 
                recipe_names << "#{i+1}. #{recipe}"
            end 

            puts "Here are some recipes that have #{user_input}."
            puts recipe_names 
            view_recipe
            # puts Rainbow("
            #     Cannot find ingredient. Try something else!
            #     ").red 
            # find_recipe_by_ingredient
        end 
    end 

    def view_recipe
        puts "#{line_break}"
        puts "Please enter the name of the recipe you would like to see."
        puts "#{line_break}"
        user_input = gets.chomp.downcase
        recipe_api = view_recipe_api(user_input)

        # binding.pry

        if recipe_api['title'].downcase.include?(user_input)
            puts "#{line_break}"
            puts "Recipe: #{recipe_api["title"]}"
            puts "Link to Recipe: #{recipe_api["href"]}"
            puts "Ingredients: #{recipe_api["ingredients"]}"
            puts "#{line_break}"
            create_favorite(user_input)
        else
            puts "Invalid input, please try again."
            view_recipe 
        end
        # add downcase when we get api info
        # if Recipe.exists?(:name => user_input.downcase)
        #     recipe = Recipe.find_by(:name => user_input.downcase)
        #     #puts recipe.name #and more info about the recipe

            # puts "Would you like to save this recipe to your favorites? (yes/no) "
            # user_input = gets.chomp.downcase
            #     if user_input == 'yes'
            #         result = UserRecipe.all.select{|ur| ur.user_id == $user.id}
            #         id_array = result.map{|ri| ri.recipe_id}
            #         name_array = id_array.map do |id|
            #             recipe_name = Recipe.find(id)
            #             recipe_name.name
            #         end
                    
            #         if name_array.include?(recipe.name)
            #             puts Rainbow("
            #                 This recipe is already in your favorites
            #                 ").red
            #             menu
            #         else 
            #             puts "Please give this recipe a rating(0-10)"
            #             input = gets.chomp 
            #             UserRecipe.create(user_id: $user.id, recipe_id: recipe.id, rating: input.to_i)
            #             puts Rainbow("Recipe saved!").cyan
            #             menu
            #         end

            #     else
            #         menu
            #     end
        # else 
        #     puts Rainbow("
        #         Cannot find recipe. Try something else!
        #         ").red
        #     view_recipe 
        # end
    end

    def view_recipe_favorites
        puts "#{line_break}"
        puts "Please enter the name of the recipe you would like to see."
        puts "#{line_break}"
        user_input = gets.chomp.downcase
        recipe_api = view_recipe_api(user_input)

        if recipe_api['title'].downcase.include?(user_input)
            puts "#{line_break}"
            puts "Recipe: #{recipe_api["title"]}"
            puts "Link to Recipe: #{recipe_api["href"]}"
            puts "Ingredients: #{recipe_api["ingredients"]}"
            puts "#{line_break}"
            return_to_menu
        else
            puts "Invalid input, please try again."
            view_recipe_favorites
        end

    end 

    def return_to_menu    
        puts "Would you like to go back to the menu? (yes/no)" 
            input = gets.chomp.downcase
            if input == 'yes'
                menu
            elsif input == 'no'
                view_recipe_favorites
            else
                puts "Invalid input. Please type 'yes' or 'no'"
                return_to_menu 
            end 
    end 

    def create_favorite(input)
        recipe = Recipe.find_by(:name => input.downcase)
        puts "Would you like to save this recipe to your favorites? (yes/no) "
            input = gets.chomp.downcase
                if input == 'yes'
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
                        rating_input = gets.chomp 
                        UserRecipe.create(user_id: $user.id, recipe_id: recipe.id, rating: rating_input.to_i)
                        puts Rainbow("Recipe saved!").cyan
                        menu
                    end

                else
                    menu
                end
    end 


    def favorite_recipes
        favorites = []
        result = UserRecipe.all.select{|ur| ur.user_id == $user.id}
        result.each_with_index do |ur, i|
            recipe = Recipe.find(ur.recipe_id)
            favorites << "#{i+1}. #{recipe.name.capitalize}"
        end
        puts "Here are your favorite Recipes!"
        puts "#{line_break}"
        puts favorites
        view_recipe_favorites
    end

    def delete_recipe
        favorites = []
        final = nil
        result = UserRecipe.all.select{|ur| ur.user_id == $user.id}
        result.each_with_index do |ur, i|
            final = Recipe.find(ur.recipe_id)
            favorites << "#{i+1}. #{final.name.capitalize}"
        end
        puts "Here are your favorite Recipes!"
        puts "#{line_break}"
        puts favorites
        puts "Please enter the name of the recipe you would like to delete."

        user_input = gets.chomp.downcase
        if final.name.downcase.include?(user_input)
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
        else 
            puts "Invalid input, please try again."
            delete_recipe
        end
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

        view_recipe_favorites
        
        return_to_menu

    end

    def delete_account
        puts "Do you want to delete this account?(yes/no)"
        user_input = gets.chomp.downcase
            if user_input == 'yes'
                User.all.delete($user)
                puts Rainbow(" 
            Your account has been deleted!
            ").red
                puts ("
                Thank you!
                ")
                exit 
            elsif user_input == 'no' 
                menu 
            else 
                puts "Invalid input. Please type 'yes' or 'no'"
                delete_account
            end 
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