module QueriesHelper
  require 'httparty'
    # tmdb key to make api calls
    @@api_key = ENV['TMDB_KEY']

    def search_query(query)
      uri = "https://api.themoviedb.org/3/search/movie?query=#{query.query}&api_key=#{@@api_key}&language=it&page=1&include_adult=false"

      begin
        resp = HTTParty.get(uri, headers: {"Accept" => "application/json"})
        resp.inspect

        (new_movies, all_movies) = filter_existing_movies(resp["results"])

        new_movies.each do |m|
          if m["overview"].blank? || m["poster_path"].blank?
            all_movies -= [m["id"]]
            next
          end
          movie = Movie.new(
            api_id: m["id"],
            title: m["title"],
            overview: m["overview"],
            vote_average: m["vote_average"],
            release_date: m["release_date"]
          )
          movie.poster_path = "https://image.tmdb.org/t/p/w500#{m["poster_path"]}" if m["poster_path"]
          movie.url = "https://www.themoviedb.org/movie/#{m["id"]}" if m["id"]

          if !movie.save
            movies.errors.full_messages.each {|ms| query.errors.add(:movies, "==> #{ms}")}
          end
        end

        query.movies = all_movies
        rescue => e
          logger.error "Rescued from #{e.inspect}, searching query"
          query.errors.add(:query, "Internal error parsing API response")
      end

      query
    end

  def filter_existing_movies(resp)
    ids = resp.map {|movie|  movie["id"]}

    found = Movie.where("api_id IN (?)", ids).select(:api_id).map {|m| m.api_id}

    missing = ids - found
    return resp.select {|m| missing.include?(m["id"])}, ids
  end
end
