class Event < ActiveRecord::Base
    belongs_to :concert
    belongs_to :user

end