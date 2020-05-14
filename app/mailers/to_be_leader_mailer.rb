class ToBeLeaderMailer < ApplicationMailer
  default from: 'from@example.com'

  def to_be_leader_mail(team)
    @team = team
    mail to: @team.owner.email, subject: I18n.t('views.messages.edit_team_leader')
  end
end
