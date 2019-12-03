class Concert < ActiveRecord::Base
    belongs_to :events
    has_many :users, through: :events


end