require 'pony'
module Mailer
  def self.send_email(email_address, subject, body, gmail_username, gmail_password)
    return if body.nil?

    Pony.mail({
        :to => email_address,
        :body => body,
        :subject => subject,
        :via => :smtp,
        :via_options => {
          :address => 'smtp.gmail.com',
          :port => '587',
          :enable_starttls_auto => true,
          :user_name => gmail_username,
          :password => gmail_password,
          :authentication => :plain,
          :domain => 'localhost.localdomain'
        }
    })

    puts "sent to #{email_address}"
  end
end
