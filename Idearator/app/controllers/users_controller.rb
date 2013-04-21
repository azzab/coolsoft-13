class UsersController < ApplicationController
	before_filter :authenticate_user!, :only => [:deactivate, :confirm_deactivate, :activate, :expertise, :new_committee_tag, :change_settings]


# displays a form where the user enters his password to confrim deactivation.
# Params: none
# Author: Amina Zoheir
def confirm_deactivate
@user = current_user
end


# checks the entered password if it's the current users password
# it changes the value of his active field to false and signs him out.
# Params:
# +password+:: the parameter is an instance of +User+ passed through the form form confirm deactivate.
# Author: Amina Zoheir
def deactivate
  if current_user.is_a? Committee
    @password = params[:committee][:password]
  else
    @password = params[:user][:password]
  end

  if current_user.valid_password?(@password)
    current_user.active = false
    current_user.save
    sign_out current_user
    respond_to do |format|
     format.html { redirect_to  '/' , notice: 'Successfully deactivated' }
     format.json { head :no_content }
  end
  else
    respond_to do |format|
     format.html { redirect_to action: 'confirm_deactivate' 
      flash[:notice] = 'Wrong password' }
     format.json { head :no_content }
    end
  end
end

# sets the active field of the current user to true
# Params: none
# Author: Amina Zoheir
def activate
  current_user.active = true
  respond_to do |format|
    format.html { flash[:notice] = 'Successfully reactivated' }
    format.json { head :no_content }
  end
end

# Pass the current_user and all the tags to the  expertise view
# Params:
# none
# Author: Mohamed Sameh
def expertise
  if current_user.is_a? Committee
    if Tag.all.count > 0
      @user= current_user
      @tags= Tag.all
    else
      respond_to do |format|
      format.html{
        redirect_to controller: 'home', action: 'index'
      }
    end
    end
  else
    respond_to do |format|
      format.html{
        redirect_to controller: 'home', action: 'index'
      }
    end
  end
end


  #This method is used to generate the view of each User Profile. A specific user and his ideas are made
  #available to the view to be presented in the appropriate manner.
  #Author: Hisham ElGezeery
  def show
    @user = User.find(params[:id])
    @ideas = Idea.find(:all, :conditions => { :user_id => @user.id })
    @admin = current_user
    respond_to do |format|
      format.html{
        redirect_to controller: 'home', action: 'index'
      }
    end
  end
end


	# POST /users
  # POST /users.json
	
# This method creates a new User and calls UserMailer to send a confirmation email.
#Author: Menna Amr
def create
  @user = User.new(params[:user])
  respond_to do |format|
    if @user.save
      # Tell the UserMailer to send a welcome Email after save
      UserMailer.welcome_email(@user).deliver
      format.html { redirect_to(@user, :notice => 'User was successfully created.') }
      format.json { render :json => @user, :status => :created, :location => @user }
    else
      format.html { render :action => 'new' }
      format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Enter chosen notification settings chosen by user in table User
	# Params:
	# +user[]+:: the parameter is an instance of +user+ passed through the form from settings action
	# Author: Mohamed Sameh
  def change_settings
		if params[:user] != nil
			settings= params[:user]
			s= User.find(current_user)
			if settings.include?('1')
				s.own_idea_notifications= true
			else
				s.own_idea_notifications= false
			end
			if settings.include?('2')
				s.participated_idea_notifications= true
			else
				s.participated_idea_notifications= false
			end
			s.save
		else
			s= User.find(current_user)
			s.own_idea_notifications= false
	   	s.participated_idea_notifications= false
			s.save
	  end
	  respond_to do |format|
	  	format.js {}
	  end
	end


#is used to edit a specific user profile.
#Author: Hesham Nabil.
def edit
 @user = User.find(params[:id])
end

#is used to update a user's info.
#Params:
#+about_me+:: the parameter is an instance of +User+ passed through the form 'form'.
#Author: Hesham Nabil.
def update
  @user = User.find(params[:id])
  if @user.update_attributes(:about_me => params[:user][:about_me] , :photo => params[:user][:photo])
     redirect_to @user
  else
     render 'edit'
  end
end

end
