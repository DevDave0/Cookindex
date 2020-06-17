# CookIndex: A recipe command line program
Flatiron School's module 1 project. 

![cookindex](https://github.com/DevDave0/ruby-project-guidelines-wdc01-seng-ft-060120/blob/master/cookindex.png)

## Project Details

Cookindex is a command line application that allows a user to:
1. Create an account that remembers recipes saved to that account. 
2. Search for new recipes given an ingredient.
3. Allows users to save recipes to a favorites list.
4. Rate recipes on a scale of 1-10.
5. Delete recipes off the users favorites. 
6. Delete the account of the user. 

Video Demo link: 

This application gathers its recipe data from the API: recipepuppy.com

## Installation Instructions
1. Clone repository to your computer.
2. Run `bundle install` to install required Gems.
3. Run `rake db:migrate` to migrate the schema.
4. Run `ruby bin/run.rb` to enter into the application. 

Installed gems include: `rainbow - https://github.com/sickill/rainbow`