class Idea < ActiveRecord::Base

  attr_accessible :title, :body, :description, :problem_solved ,:photo, :approved
  belongs_to :user
  has_many :comments
  has_many :action_notifications
  has_many :ratings
  has_and_belongs_to_many :committees
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :users, :join_table => :votes
  has_attached_file :photo, :styles => { :small => "60x60>", :thumb => "10x10!" }, :default_url => "/images/:style/missing.png"
  searchable do
  	test :title,:description
  end
end
