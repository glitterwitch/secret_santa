require 'mandrill'

module Mailer
  def self.send_email(email_address, subject,body)
    return if body.nil?

    mailer = Mandrill::API.new
    config = {
      html: body,
      from_email: ENV['FROM_EMAIL'],
      from_name: ENV['FROM_NAME'],
      subject: subject,
      to: [ {email: email_address} ],
      async: true
    }
    result = mailer.messages.send(config)
    (result.first)[:status] == "sent"

    puts "sent to #{email_address}"
  end
end
