class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[destroy]
  before_action :require_owner_id_or_agenda_creater, only: %i[destroy]


  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
    if @agenda.destroy
      redirect_to dashboard_url, notice: I18n.t('views.messages.destroy_agenda')
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end

  def require_owner_id_or_agenda_creater
    unless current_user.id == Team.find(current_user.keep_team_id).owner_id || current_user.id == Agenda.find_by(id: params[:id]).user_id
      redirect_to dashboard_url, notice: I18n.t('views.messages.cannot_destroy_agenda')
    end
  end
end
