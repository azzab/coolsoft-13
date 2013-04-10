require 'spec_helper'

describe CommitteesController do
  describe 'PUT archive' do
    include Devise::TestHelpers
    
    
    describe "review_ideas"
      it "renders unapproved ideas with the area of expertise of the committee member" do
        @committee=Committee.new
        @committee.email='c@gmail.com'
        @committee.password=123123123
        @committee.username='c'
        @committee.approved=true
        @committee.confirm!
        @committee.save
        @idea=Idea.new
        @idea.title='bla'
        @idea.problem_solved='bla'
        @idea.description='bla'
        @idea.save
        @tag=Tag.new
        @tag.name='t1'
        @tag.save
        @committee.tags << @tag
        @idea.tags << @tag
        sign_in(@committee)
        get :review_ideas
        assigns(:ideas).should ==[@idea]
      end
      it "doesnt render unapproved ideas with diffrent area of expertise of the committee member" do
        @committee=Committee.new
        @committee.email='c@gmail.com'
        @committee.password=123123123
        @committee.username='c'
        @committee.approved=true
        @committee.confirm!
        @committee.save
        @idea=Idea.new
        @idea.title='bla'
        @idea.problem_solved='bla'
        @idea.description='bla'
        @idea.save
        @tag=Tag.new
        @tag.name='t1'
        @tag.save
        @committee.tags << @tag
        sign_in(@committee)
        get :review_ideas
        assigns(:ideas).should ==[]
      end 
      it "doesnt render approved ideas with diffrent area of expertise of the committee member" do
        @committee=Committee.new
        @committee.email='c@gmail.com'
        @committee.password=123123123
        @committee.username='c'
        @committee.approved=true
        @committee.confirm!
        @committee.save
        @idea=Idea.new
        @idea.title='bla'
        @idea.problem_solved='bla'
        @idea.description='bla'
        @idea.approved=true
        @idea.save
        @tag=Tag.new
        @tag.name='t1'
        @tag.save
        @committee.tags << @tag
        sign_in(@committee)
        get :review_ideas
        assigns(:ideas).should ==[]
      end 
    end
    describe "disapprove" do
      it "changes the approved status of the idea" do
        @idea=Idea.new
        @idea.title='bla'
        @idea.problem_solved='bla'
        @idea.description='bla'
        @idea.save
        @idea.approved=true
        get :disapprove, :id => @idea.id
        @idea.reload
        (@idea.approved).should eql(false)
      end
    end
    describe "add_rating" do
      it "approves the idea" do
        @idea=Idea.new 
        @idea.title='bla'
        @idea.problem_solved='bla'
        @idea.description='bla'
        @idea.save  
        puts "hash 1 "
        get :add_rating , :id => @idea.id, :rating => ['ay 7aga']
        @idea.reload
        (@idea.approved).should eql(true)
      end
    end
  end
#end