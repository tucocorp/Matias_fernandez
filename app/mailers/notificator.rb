class Notificator < ActionMailer::Base
  default from: ENV['DEVISE_MAIL_SENDER']
  layout 'notificator_base'

  def activities_for_evaluation(activities)
  end

  def send_agenda(meeting, attendee)
    @meeting  = meeting
    @attendee = attendee
    @user     = attendee.user

    attachments['meeting.ics'] = meeting.to_ical
    mail(to: @user.email, subject: meeting.name).deliver
  end

  def send_minute(meeting, attendee)
    @meeting    = meeting
    @project    = meeting.project

    @attendee   = attendee
    @user       = attendee.user
    @member     = @project.project_members.where(user: @user).first

    mail(to: @user.email, subject: "Minuta: #{meeting.name}").deliver
  end
end
