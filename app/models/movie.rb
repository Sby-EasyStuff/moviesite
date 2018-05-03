class Movie < ApplicationRecord
  has_one :trailer
  has_many :comments

end
