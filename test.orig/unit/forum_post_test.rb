require File.dirname(__FILE__) + '/../test_helper'

class ForumPostTest < Test::Unit::TestCase
  fixtures :users, :forums, :forum_posts

  def test_create_post_and_reply
    pst = ForumPost.new( :user_id => users(:quentin),
      :subject => 'Subject',
      :body => 'Body body, wanna ....',
      :forum_id => 1)
    
    assert pst.save
    assert_not_nil ForumPost.find_by_subject('Subject')
    
    reply = ForumPost.new( :user_id => users(:aaron),
      :subject => 'Reply',
      :body => 'Reply body body',
      :parent_id => pst.id,
      :forum_id => 1)
    
    assert reply.save    
    assert reply.child?
    
    pst.reload
    
    assert pst.root?
    assert_equal 1, pst.all_children().size
    assert_equal reply, pst.all_children()[0]    
  end
  
end
