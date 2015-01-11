class Notifier < ActionMailer::Base

  default from: 'notificaciones@regalar.com.ar'
  layout 'email'

end
