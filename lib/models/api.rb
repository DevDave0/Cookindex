require 'rest-client'
require 'json'
require 'pry'

def get_specific_recipe_from_api(user_input)
    url = "http://www.recipepuppy.com/api/?i=#{user_input}"
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
    results_hash = response_hash["results"]
    recipe = []
    results_hash.each do |results|
        if results["ingredients"].include?(user_input)
            recipe << results["title"]
            Recipe.find_or_create_by(name: results["title"].downcase)
        end
    end
    recipe
end

def view_recipe_api(input)
    x = input.gsub(" ", "+")
    url = "http://www.recipepuppy.com/api/?q=#{x}"
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
    results_hash = response_hash["results"]
    results_hash[0]
end