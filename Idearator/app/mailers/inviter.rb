class Inviter < ActionMailer::Base
  default from: "coolsoft@gmail.com"

# returns invitation email
# Params:
# +email+:: the email of the guest
# Author: muhammed hassan
   def invite_email(email )
    @email = email
    @type = 'committee'
    @address = 'idearator.com'
    return mail(:to => email, :subject => "Welcome to My Awesome Site")
  end

end
