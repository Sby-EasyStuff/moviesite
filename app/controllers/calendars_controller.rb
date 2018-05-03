class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie, only: [:create, :destroy]
  before_action :set_event, only: [:destroy]
  before_action :set_session, only: [:create, :destroy]

  @@movie = 0

  def redirect
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    session[:authorization] = response

    if !session[:return_to].nil?
      redirect_to session.delete(:return_to)
    else
      redirect_to root_path
    end
  end

  def create
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: @@movie.release_date),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: @@movie.release_date + 1),
      summary: "Uscita #{@@movie.title} nelle sale. Evento aggiunto tramite moviesite",
      sendNotifications: true,
      creator: {
        displayName: "Moviesite"
      }
    })

    @new_event = service.insert_event('primary', event)

    if @new_event.status == "confirmed"
      @event = Event.new(api_id: @new_event.id, user_id: current_user.id, movie_id: @@movie.id)
      if @event.save
        redirect_to session.delete(:return_to), notice: "Evento aggiunto con successo!"
        return
      end
      redirect_to session.delete(:return_to), alert: "Errore aggiunta evento!"
      return
    end

  rescue ArgumentError
    redirect_to redirect_path
    return
  end

  def destroy

    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    @get_event = service.get_event('primary', @event.api_id)
    @delete_event = service.delete_event('primary', @event.api_id)

    if @delete_event.blank?
      @event.destroy

      redirect_to session.delete(:return_to), notice: "Evento eliminato con successo!"
    end

  rescue ArgumentError
    redirect_to redirect_path
    return
  end

  private

  def client_options
    {
      client_id: ENV['GOOGLE_APP_ID'],
      client_secret: ENV['GOOGLE_APP_SECRET'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url
    }
  end

  def client_error_handling(error)
     puts(error.status_code)
     case error.status_code
     when 400
       redirect_to session.delete(:return_to), alert: "Errore nei parametri della richiesta"
     when 403
       redirect_to session.delete(:return_to), alert: "Limite richieste giornaliere raggiunto"
     when 404
       @event.destroy
       redirect_to session.delete(:return_to), notice: "Evento eliminato con successo"
     else
       redirect_to session.delete(:return_to), alert: "Errore rimozione evento!"
     end
     return
  end

  def oauth_error_handling(error)
    redirect_to redirect_path
    return
  end

  def set_session
    session[:return_to] ||= request.referer
  end

  def set_event
    @event = Event.where("user_id = ? AND movie_id = ?", current_user.id, @@movie.id).first
    redirect_to session.delete(:return_to), alert: 'Il film non è stato trovato' unless @@movie
  end

  def set_movie
    @@movie = Movie.find_by_id(params[:movie_id])
    redirect_to session.delete(:return_to), alert: 'Il film non è stato trovato' unless @@movie
  end
end
