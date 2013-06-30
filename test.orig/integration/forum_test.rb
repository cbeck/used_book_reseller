require "#{File.dirname(__FILE__)}/../test_helper"

class ForumTest < ActionController::IntegrationTest
  fixtures :forum_groups, :forums, :forum_posts, :users

  def test_forum
    quentin = enter_site(:quentin)
    forum_group = quentin.views_all_forums_and_selects_forum_group
    quentin.views_forum_page forum_group
    forum = quentin.selects_forum
    quentin.views_posts forum
    quentin.tries_to_post forum
    quentin.logs_in("quentin", "test", forum)
    q_post = quentin.posts_to_forum forum
    
    aaron = enter_site(:aaron)
    aaron.logs_in("aaron", "test")    
    posts = aaron.searches_forums
    a_post = aaron.selects_post_from_results q_post
    a_reply = aaron.replies_to_post(forum, a_post)
    
    quentin.views_posts forum
    reply = quentin.notes_new_reply q_post
    
    quentin.is_reply_aarons_post?(reply, a_reply)
    q_post.reload
    print "quentin's post is now "
    p q_post
  end
  
  private
  
  module ForumTestDSL
    include ERB::Util
    
    attr_writer :name
    
    def views_all_forums_and_selects_forum_group
      get forum_groups_url
      assert_response :success
      groups = assigns(:forum_groups)
      assert_not_nil groups
      puts "selected forum group"
      groups[0]      
    end
    
    def views_forum_page(forum_group)
      get forum_group_url(forum_group)
      assert_response :success
      assert assigns(:forums)
      puts "viewed forum"
    end
    
    def selects_forum
      get forum_url(forums(:general_forum))
      assert_response :success
      assert assigns(:forum)
      puts "selected forum"
      forum = assigns(:forum)
    end
    
    def views_posts(forum)
      get forum_posts_url(:forum_id => forum)
      assert_response :success
      assert assigns(:forum_posts)
      puts "viewed posts"
    end
    
    def tries_to_post(forum)
      get new_forum_post_url(:forum_id => forum)
      assert_response :redirect
      puts "redirected when trying to post"
    end
    
    def logs_in(user_name, password, forum=nil)
      post sessions_url, :login => user_name, :password => password
      assert_response :redirect
      if forum.nil?
        assert_redirected_to "/site/index"
      else
        assert_redirected_to new_forum_post_url(:forum_id => forum)
      end
      puts "logged in"
    end
    
    def posts_to_forum(forum)
      post_via_redirect forum_posts_url(:forum_id => forum),
        :forum_post => {:user_id => users(:quentin).id,
          :subject => 'Subject',
          :body => 'Body body, wanna ....'}
      assert_response :success
      assert assigns(:forum_post)
      puts "posted to forum"
      d_post = assigns(:forum_post)
      assert d_post.parent_id.to_i.zero?
      d_post
    end
    
    # need to use ferret to search posts?
    def searches_forums
      posts = ForumPost.find(:all)
    end
    
    # add ferret
    def selects_post_from_results(d_post)
      get reply_forum_post_url(:forum_id => d_post.forum, :id => d_post)
      assert_response :success
      #assert_template :new
      d_post
    end
    
    def replies_to_post(forum, d_post)
      p d_post
      post_via_redirect forum_posts_url(:forum_id => forum), 
        :forum_post => {:user_id => users(:aaron).id,
          :subject => 'Reply',
          :body => 'Reply body body',
          :parent_id => d_post.id}
      assert_response :success
      assert assigns(:forum_post)
      a_reply = assigns(:forum_post)
      #assert a_reply.child?
      a_reply.reload
      p a_reply
      a_reply
    end
    
    def notes_new_reply(d_post)
      user = User.find(d_post.user_id)
      print "user login is "
      puts user.login
      my_post = user.forum_posts.find(d_post)
      assert my_post.root?
      assert_equal 1, my_post.direct_children.size
      chillins = my_post.direct_children
      reply = chillins[0]
      assert_not_nil reply
      reply
    end
    
    def is_reply_aarons_post?(reply, d_post)
      print "reply is "
      p reply
      print "post is "
      p d_post
      assert reply.id == d_post.id
    end
    
   
  end
  
  def enter_site(name)
    open_session do |session|
      session.extend(ForumTestDSL)
      session.name = name
      yield session if block_given?
    end
  end
end
