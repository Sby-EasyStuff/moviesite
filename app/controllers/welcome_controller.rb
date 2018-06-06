class WelcomeController < ApplicationController
  def index
    if !current_user.blank? && Subscriber.find_by(user: current_user.id)
      connection = Bunny.new ENV['CLOUDAMQP_URL']
      connection.start

      channel = connection.create_channel
      exchange = channel.fanout('movies_update')
      queue = channel.queue("#{current_user.id}")
      queue.bind(exchange)

      begin
        queue.subscribe(block: false) do |delivery_info, properties, body|
          map_last_movies(Query.last) unless body.to_i == current_user.id
        end
        channel.close
        connection.close
      rescue Interrupt => _
        channel.close
        connection.close
      end
    end
  end

  private
  def map_last_movies(query)
      @last_movie_ids = query.movies[1, query.movies.length-2]
      @last_movie_ids = @last_movie_ids.split(", ")
      @last_movie_ids = @last_movie_ids.map{|m| m.to_i}
      @last_movies = Movie.where("api_id IN (?)", @last_movie_ids)
  end
end
