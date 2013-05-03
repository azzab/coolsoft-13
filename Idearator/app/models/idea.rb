class Idea < ActiveRecord::Base
  after_save SimilarityEngine::IdeaHooks.new

  attr_accessible :title, :description, :problem_solved, :photo, :num_votes, :user_id, :approved, :tag_ids

  validates_length_of :title, :maximum => 50
  validates_length_of :description, :maximum => 1000
  validates_length_of :problem_solved, :maximum => 1000

  after_save TrendsController::IdeaHooks.new

  belongs_to :user
  belongs_to :committee
  has_one :daily_vote_count, class_name: 'VoteCount'
  has_many :comments
  has_many :idea_notifications, :dependent => :destroy
  has_many :competition_idea_notifications, :dependent => :destroy
  has_many :delete_notifications
  has_many :ratings
  has_and_belongs_to_many :tags

  has_many :votes
  has_many :voters, :through => :votes, :source => :user
  has_many :competition_entries
  has_many :competitions, :through => :competition_entries, :source => :competition
  has_many :winning_competitions, :class_name => 'Competition'
  has_one :trend

  has_many :similarities
  has_many :similar_ideas, through: :similarities, conditions: ['similarity > ? AND approved = ? AND rejected = ?', 5, 't', 'f'], limit: 5

  has_attached_file :photo, :styles => { :small => '60x60>', :medium => "300x300>", :thumb => '10x10!' }, :default_url => 'missing.png'

  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      find(:all)
    end
  end

  #Adds the idea of the highest votes in the month of the input date
  #+date+::
  #Author Omar Kassem
  def self.best_idea_for_month(date)
    start_date = date
    start_date = start_date - (start_date.day - 1).day
    end_date = start_date + 1.month
    ideas = Idea.where(:created_at => start_date..end_date).reorder('num_votes')
    idea = MonthlyWinner.new
    puts ideas.count
    idea.idea_id = ideas.last.id
    idea.save
  end

  # send notification  to users who voted for this idea  when the idea submitter edit his idea
  # Params:
  # +user+:: the parameter instance of user
  # Author:: Marwa Mehanna
  def send_edit_notification(user)
    voters=self.voters
    voters.each{|u|
      if u.participated_idea_notifications
        EditNotification.send_notification(user, self, [u])
      end
    }
  end

end
