class Movie < ApplicationRecord
  has_many :events
  has_one :trailer
  has_many :comments

end
