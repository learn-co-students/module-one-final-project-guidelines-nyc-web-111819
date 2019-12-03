class Event < ActiveRecord::Base
    has_many :concerts
    has_many :users
    
end