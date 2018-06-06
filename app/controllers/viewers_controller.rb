class ViewersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :get_viewer, except: [:index, :events]
  before_action :same_viewer, only: [:edit, :update]

  def index
    @viewers = User.all
  end

  def show
    @events = Event.includes(:movie).where("user_id = ? ", @viewer.id)
    @subscriber = Subscriber.find_by("user_id = ?", @viewer.id)
  end

  def events
    @events = Event.includes(:movie).where("user_id = ? ", params[:viewer_id])
    @future = @events.map{ |e| e.movie unless (e.movie.release_date < Date.today) }.compact
    @past = @events.map{ |e| e.movie unless (e.movie.release_date > Date.today) }.compact
    render 'events'
  end

  def edit
  end

  def update
    if @viewer.update_attributes(viewer_params)
      redirect_to viewer_path(@viewer), notice: "Utente aggiornato con successo"
    else
      render :edit
    end
  end

  private
    def get_viewer
      @viewer = User.find_by_id(params[:id])
      redirect_to viewers_path, alert: "Utente non trovato" unless @viewer
    end

    def same_viewer
      redirect_to viewers_path, alert: "Non sei autorizzato a eseguire quest'azione" if current_user != @viewer
    end

    def viewer_params
      params.require(:viewer).permit(:name, :photo)
    end

end
