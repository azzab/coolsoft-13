class UserMailer < ActionMailer::Base
  default from: "menna.amr2@gmail.com"

#Sends email to user after Sign Up
    def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/users/login"
    mail(:to => user.email, :subject => "Welcome to Shoghlana!")
  end
end
