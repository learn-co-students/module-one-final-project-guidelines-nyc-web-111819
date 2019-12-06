# require 'pry'
require_relative "../lib/api.rb"

# User.destroy_all
# Line.destroy_all
# Search.destroy_all

u1 = User.create(user_name: "Alex", password: "password")
u2 = User.create(user_name: "Natalie", password: "nat123")


# fake_train = Line.create(train_name: "H", status: "All good")

sorting_api_data

# search1 = Search.create(user_name: "Natalie", train_name: "4")
# search2 = Search.create(user_name: "Natalie", train_name: "5")
# search3 = Search.create(user_name: "Natalie", train_name: "6")
# search4 = Search.create(user_name: "Alex", train_name: "Q")
# search5 = Search.create(user_name: "Alex", train_name: "F")
# search6 = Search.create(user_name: "Alex", train_name: "2")