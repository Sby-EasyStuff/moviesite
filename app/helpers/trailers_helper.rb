module TrailersHelper
  require 'httparty'
    # tmdb key to make api calls
    #@@api_key = ENV['YT_KEY']

    @@api_key = "AIzaSyDBvEmsIW5pAn2JSdHd4UjAGrK0Obovjos"

    def search_trailer(movie)

      encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => '',        # Use a blank for those replacements
        :universal_newline => true       # Always break lines with \n
      }
      title = movie.title.encode(Encoding.find('ASCII'), encoding_options)
      uri = "https://www.googleapis.com/youtube/v3/search/?type=video&q=#{title} trailer&maxResults=10&part=snippet&key=#{@@api_key}&relevanceLanguage=it"

      begin
        resp = HTTParty.get(uri, headers: {"Accept" => "application/json"})
        resp.inspect

        trailer = filter_result(resp["items"])

        trailer = Trailer.new(
          api_id: trailer["id"]["videoId"],
          thumbnail: trailer["snippet"]["thumbnails"]["default"]["url"],
          movie_id: movie.id
        )

        puts(trailer)

        if !trailer.save
          puts("In If")
          trailer.errors.full_messages.each {|t| movie.errors.add(:triler, "==> #{t}")}
        end

      rescue => e
        logger.error "Rescued from #{e.inspect}, searching trailer"
        movie.errors.add(:movie, "Internal error parsing API response")
      end

      trailer
    end

  def filter_result(resp)
    for i in 0..resp.length
      title = resp[i]["snippet"]["title"]
      if title.downcase.match("trailer")
        return resp[i]
      end
    end
  end

end
