class MemberMailer < ActionMailer::Base
  def signup_notification(member)
    setup_email(member)
    @subject    = 'Welcome to Homeschool Apple!'
  end
  
  def activation(member)
    setup_email(member)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{APP_CONFIG[:domain]}/"
  end
  
  def forgot_password(member)
    recipients  member.email
    subject     'Your password change request'
    body        :member => member, :url => "http://#{APP_CONFIG[:domain]}/reset_password/#{member.password_reset_code}"
  end

  def reset_password(member)
    recipients  member.email
    subject     'Your password has been reset.'
    body        :member => member
  end
  
  def seller_items_purchased(order, seller, line_items)
    # headers     {content_type => 'text/html'}
    recipients  seller.member.email
    subject     '[hsa] Your item has been purchased'
    body        :order => order, :seller => seller, :line_items => line_items
  end
  
  def buyer_receipt(order)
    from        APP_CONFIG[:support_email]
    recipients  order.email
    subject     'Thanks for purchasing from Homeschool Apple'
    body        :order => order
  end
  
  def admin_payment_notify(pn)
    from        APP_CONFIG[:support_email]
    recipients  APP_CONFIG[:admin_email]
    subject     '[hsa] paypal payment received'
    body        :pn => pn
  end
  
  def fraud_alert(pn)
    from        APP_CONFIG[:support_email]
    recipients  APP_CONFIG[:admin_email]
    subject     '[hsa] fraud alert'
    body        :pn => pn
  end
  
  def message(mail)
    subject     mail[:message].subject
    from        mail[:member].email
    reply_to    mail[:member].email
    recipients  mail[:recipient].email
    body        mail
  end
  
  protected
    def setup_email(member)
      @recipients  = "#{member.email}"
      @from        = APP_CONFIG[:support_email]
      @subject     = "[#{APP_CONFIG[:domain]}] "
      @sent_on     = Time.now.utc
      @body[:member] = member
    end
end
