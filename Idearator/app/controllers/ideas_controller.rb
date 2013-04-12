class IdeasController < ApplicationController
  before_filter :authenticate_user!, :only => [:create , :edit, :update]
  # view idea of current user
  # Params
  # +id+:: is passed in params through the new idea view, it is used to identify the instance of +Idea+ to be viewed
  # Marwa Mehanna

  def show
    @idea = Idea.find(params[:id])
    if user_signed_in?
      @user = current_user.id
      @username = current_user.username
    end
    @ideavoted = @current_user.votes.detect { |w|w.id == @idea.id }
    rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @idea }
      format.js
    end
  end


def show
  @user=current_user.id
  @idea = Idea.find(params[:id])
  @likes = Like.find(:all, :conditions => {:user_id => current_user.id})
end
  # making new Idea
  #Marwa Mehanna
  def new
    @idea=Idea.new
    @tags= Tag.all
    @chosentags=[]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @idea }
    end
  end

  # editing Idea
  # Params
  # +id+ :: this is an instance of +Idea+ passed through _form.html.erb, used to identify which +Idea+ to edit
  # Author: Marwa Mehanna
  def edit   
    @idea = Idea.find(params[:id])
    @tags = Tag.all
    @chosentags = Idea.find(params[:id]).tags
    @boolean = true
    @ideavoters = @idea.votes
    @ideacommenters = @idea.comments
    @userVreceivers = []
    @userCreceivers = []
    @usersthatcommented = []
    if !@idea.votes.nil?
      @ideavoters.each { |user|
         if user.participated_idea_notifications
          @userVreceivers << user 
        end }
      EditNotification.send_notification(current_user, @idea, @userVreceivers)
    end
    list_of_comments = Comment.where(idea_id: @idea.id)
    list_of_commenters = []
    list_of_comments.each do |c|
      list_of_commenters.append(User.find(c.user_id)).flatten!
    end
    list = list_of_commenters
    if list != nil
      EditNotification.send_notification(current_user, @idea, list)
    end
  end

  # updating Idea
  # Params
  # +ideas_tags:: this is an instance of +IdeasTag+ passed through _form.html.erb, this is where +tags+ will be added
  # +tags+ :: this is an instance of +Tags+ passed through _form.html.erb, used to identify which +Tags+ to add
  # Author: Marwa Mehanna
  def update
    @idea = Idea.find(params[:id])
    puts(params[:ideas_tags][:tags])
    @idea.tag_ids = params['ideas_tags']['tags'].collect { |t|t.to_i }
    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        format.html { redirect_to @idea, notice: 'Idea was successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end 

  # Votes for a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be voted
  # Author: Marwa Mehannna
  def vote
    @idea = Idea.find(params[:id])
    current_user.votes << @idea
    @idea.num_votes = @idea.num_votes + 1
    @ideaowner = User.find(@idea.user_id)
    if @ideaowner.own_idea_notifications
     VoteNotification.send_notification(current_user, @idea, [@ideaowner])
    end
    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        format.html { redirect_to @idea, :notice =>'Thank you for voting' }
        format.json { head :no_content }
      else
        format.html { redirect_to @idea, alert: 'Sorry,cant vote' }
        format.json { head :no_content }
      end
    end
  end

  # UnVotes for a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be unvoted
  # Author: Marwa Mehannna
  def unvote
    @idea = Idea.find(params[:id])
    current_user.votes.delete(@idea)
    @idea.num_votes = @idea.num_votes - 1
    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        format.html { redirect_to @idea, :notice =>'Your vote is deleted' }
        format.json { head :no_content }
      else
        format.html { redirect_to @idea, alert: 'Idea is still voted' }
        format.json { head :no_content }
      end
    end 
  end

  # creating new Idea
  # Params
  # +idea+ :: this is an instance of +Idea+ passed through _form.html.erb, identifying the idea which will be added to records
  # +idea_tags+ :: this is an instance of +IdeaTags+ passed through _form.html.erb, this is where +tags+ will be added
  # +tags+ :: this is an instance of +Tags+ passed through _form.html.erb, used to identify which +Tags+ to add
  # Author: Marwa Mehanna
  def create
    @idea = Idea.new(params[:idea])
    @idea.user_id = current_user.id
    respond_to do |format|
      if @idea.save
        @tags = params[:ideas_tags][:tags]
        @tags.each do |tag|
          IdeasTags.create(:idea_id => @idea.id, :tag_id => tag)
        end
        format.html { redirect_to @idea, notice: 'idea was successfully created.' }
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.html { render action: 'new' }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end
  #create new like
  #Params:
  #+comment_id+ :: the parameter is an instance   
  # of +Comment+ and it's used to build the like after clicking like
  #The def checks if the user liked the comment before if not the num_likes is incremented
  #by 1 else nothing happens
  #author dayna
  def like
    @idea = Idea.find(params[:id])
    @commentid = params[:commentid]
    if params[:commentid] != nil
      @commentid = params[:commentid]
      @comment = Comment.find(:first, :conditions => {:id => @commentid})
      if Comment.exists?(:id => @commentid)
        @comment.num_likes = @comment.num_likes + 1
        @comment.save
        @like = Like.new
        @like.user_id = current_user.id
        @like.comment_id = @commentid
        @like.save
        @likes = Like.find(:all, :conditions => {:user_id => current_user.id})
        respond_to do|format|
          format.js
        end
      else
        redirect_to @idea , :notice => "This comment was removed by the user"

  # Archives a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be archived
  # Author: Mahmoud Abdelghany Hashish
  def destroy
    idea = Idea.find(params[:id])
    if current_user.id == idea.user_id
      list_of_comments = Comment.where(idea_id: idea.id)
      list_of_commenters = []
      list_of_voters = idea.votes
      idea.destroy
      list_of_comments.each do |c|
        c.destroy
      end  
      list_of_comments.each do |c|
        list_of_commenters.append(User.find(c.user_id)).flatten!
      end
      list = list_of_commenters.append(list_of_voters).flatten!
      DeleteNotification.send_notification(current_user, idea, list)
      respond_to do |format|
        format.html { redirect_to '/', alert: 'Your Idea has been successfully deleted!' }
      end
    else
      respond_to do |format|
        format.html { redirect_to idea, alert: 'You do not own the idea, so it cannot be deleted!' }
      end
    end
  end
    def archive
      idea = Idea.find(params[:id])
      if current_user.type == 'Admin' || current_user.id == idea.user_id
        idea.archive_status = true
        idea.save
        list_of_commenters = []
        idea.comments.each do |c|
          list_of_commenters.append(User.find(c.user_id)).flatten!
        end
        list = list_of_commenters.append(idea.votes).flatten!
        if current_user.type == 'Admin'
          list.append(User.find(idea.user_id)).flatten!
        end
        ArchiveNotification.send_notification(current_user, idea, list)
        idea.votes.each do |u|
          idea.votes.delete(u)
        end
        idea.comments.each do |c|
          c.destroy
        end  
        respond_to do |format|
          format.html { redirect_to idea, alert: 'Idea has been successfully archived.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to idea, alert: "Idea isn't archived, you are not allowed to archive it." }
          format.json { head :no_content }
        end
      end
    end

  # Unarchives a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be unarchived
  # Author: Mahmoud Abdelghany Hashish    
  def unarchive
    idea = Idea.find(params[:id])
    if current_user.type == 'Admin' || current_user.id == idea.user_id
      idea.archive_status = false
      idea.save
      respond_to do |format|
        format.html { redirect_to idea, alert: 'Idea has been successfully unarchived.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to idea, alert: "Idea isn't archived, you are not allowed to archive it." }
        format.json { head :no_content }
      end
    end
  end
end

