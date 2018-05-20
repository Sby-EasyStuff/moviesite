class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.new(user_id: current_user.id)
    if @subscriber.save
      connection = Bunny.new ENV['CLOUDAMQP_URL']
      connection.start

      channel = connection.create_channel
      exchange = channel.fanout('movies_update')
      queue = channel.queue("#{current_user.id}")
      queue.bind(exchange)
      channel.close
      connection.close
      redirect_to viewer_path(current_user), notice: 'Adesso riceverai notifiche aggiornate'
    else
      redirect_to viewer_path(current_user), alert: 'Iscrizione non riuscita'
    end
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:user_id)
  end

end
