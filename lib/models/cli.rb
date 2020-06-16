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
        end

    end 







    # helper methods

    def line_break
        return "--------------------------------------------------------------------------------------------"
    end



end