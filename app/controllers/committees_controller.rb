class CommitteesController < ApplicationController
before_filter :authenticate_user!
#generates list of ideas to be reviewed by the committee
#Author : Omar Kassem
  def review_ideas 
    @committee=current_user
    if current_user
      if @committee.type == "Committee"
        @ideas=Idea.find(:all, :conditions =>{:approved => false})
        @ideas.reject! do |i|
          (i.tags & @committee.tags).empty?         
        end
      end
    end    	
  end
#sets the approved status of the idea reviewed by the committee member
#Author : Omar Kassem  
  def disapprove
    if current_user.type == 'Committee'
      @idea=Idea.find(params[:id])
      @idea.approved = false
      @idea.save
      DisapproveIdeaNotification.send_notification(current_user, @idea, [@idea.user])
      flash[:notice] = 'The idea has been disapproved'
      redirect_to :controller => 'committees', :action => 'review_ideas'
    end
  end  

  def add_prespectives
    if current_user.type == 'Committee'
      @idea=Idea.find(params[:id])
      session[:idea_id]=params[:id]
    end
  end  
#adds the rating prespectives taken from the user from the add_prespectives view 
#to the idea reviewed and approvesthe idea
#Author : Omar Kassem  
  def add_rating
    @idea=Idea.find(session[:idea_id])
    @idea.approved = true
    @idea.save
    @rating = params[:rating]
    @rating.each do |rate|
      r = @idea.ratings.build
      r.name=rate
      r.value=0
      r.save
    end  
    respond_to do |format|
      format.js {render "add_rating"}
    end

  end
  	
end
