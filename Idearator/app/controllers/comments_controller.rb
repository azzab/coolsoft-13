class CommentsController < ApplicationController
  respond_to :html, :json

  #Show all Comments
  #Params:
  #+idea_id+ :: the parameter is an instance of +Idea+
  #passed through the form of action create
  #author dayna
  def show
    @user = current_user.id
    @username = current_user.username
    @idea = Idea.find(params[:id])
  end

  #create new Comment
  #Params:
  #+idea_id+ :: the parameter is an instance
  #of +Idea+ passed to get the id of the idea to build the comments
  #+comment_id+ :: the parameter is an instance
  # of +Comment+ and it's used to show the comments after posting it
  #author dayna
  def create
    @idea = Idea.find(params[:idea_id])
    @comment = @idea.comments.create(params[:comment])
    @comment.update_attributes(:idea_id => @idea.id)
    respond_to do |format|
     if @comment.save
       format.html { redirect_to(@idea, :notice => 'Comment was successfully created.') }
       format.xml  { render :xml => @idea, :status => :created, :location => @idea }
    else
       format.html { redirect_to(@idea, :notice => 'Comment could not be saved. Please fill in all fields') }
        format.xml { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
     end
  end

  #edit comment and update it
  #Params:
  #+comment_id+ :: the parameter is an instance of +Comment+
  #to get the comment's id in order to modify it
  #author dayna
  def edit
    @comment = Comment.find(params[:id])
    @idea = Idea.find(params[:idea_id])
  end

def update
  @comment = Comment.find(params[:id])
  @idea = Idea.find(params[:idea_id])
  respond_to do |format|
   if @comment.update_attributes(params[:comment])
      format.html { redirect_to(@idea, :notice => 'Comment was successfully updated.') }
      format.xml  { head :no_content }
   else
      format.html { render :action => 'edit' }
      format.xml  { render :xml => @idea.errors, :status => :unprocessable_entity }
   end
   end
 end

  #delete comment
  #Params:
  #+comment_id+ :: the parameter is an instance
  #of +Comment+ to get the comment's id in order to delete it
  #+idea_id+ :: the parameter is an instance of
  # +Idea+ to get the idea's id in order to modify it after deleting the comment
  #author dayna
  def destroy
    @idea = Idea.find(params[:idea_id])
    @comment = @idea.comments.find(params[:id])
    @comment.destroy
      respond_to do|format|
        format.js
      end
  end
end
