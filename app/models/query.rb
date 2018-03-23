class Query < ApplicationRecord
  validate :check_movies

  private
  def check_movies
    return if movies.blank?
    found = Movie.where("api_id IN (?)", movies).select(:api_id).map {|m| m.api_id}
    missing = movies - found
    missing.each { |m| errors.add(:query, "Non riesco a trovare il film #{m}") }
  end
end
