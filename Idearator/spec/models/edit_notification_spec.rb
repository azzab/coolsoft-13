require 'spec_helper'

describe EditNotification do
  it 'adds edit notification to idea_notifications table'do
    user1 = User.create(email: 'amina@gmail.com')
    user2 = User.create(email: 'marwa@gmail.com')
    tag = Tag.create('Software')
    idea = Idea.create
    (title: 'Idea', description: 'Idea Description', problem_solved: 'Problem')
    idea.user = user1
    idea.tags << [tag])
    EditNotification.send_notification(user1, idea, [user2])
    expect(IdeaNotification.last.type).to eq('EditNotification')
    expect(IdeaNotification.last.idea_id).to eq(idea.id)
    expect(IdeaNotification.last.user_id).to eq(user.id)
  end
end
