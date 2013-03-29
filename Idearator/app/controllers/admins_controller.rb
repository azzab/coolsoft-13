class AdminsController < ApplicationController


  # redirects to the index page
  # Author: muhammed hassan
  def index
  end
  
  # checks invitation is valid and delivers the email
  # Params:
  # +email+:: the email of the  guest
  # Author: muhammed hassan
  def invite_committee
    if User.find(:all, :conditions => {:email => params[:email]}).length ==0
      i = Invited.creates( params[:email] , 5 )
      # after integrating with login 5 shoulld be replaced with current_user.id
      if i.valid? 
        mail = Inviter.invite_email(params[:email])
        mail.deliver
        @messege = 'sucess'
      else
        @messege = i.errors.full_messages
      end
    else
      @messege = 'user already exists'
    end
  end
end
