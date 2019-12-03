# require 'pry'
require_relative "../lib/api.rb"

u1 = User.create(user_name: "Alex")
u2 = User.create(user_name: "Natalie")


fake_train = Line.create(train_name: "H", status: "All good")

sorting_api_data