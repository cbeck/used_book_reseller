class MemberObserver < ActiveRecord::Observer
  def after_create(member)
   MemberMailer.deliver_signup_notification(member)
  end

  def after_save(member)
  #   MemberMailer.deliver_activation(member) if member.recently_activated?  
    MemberMailer.deliver_forgot_password(member) if member.recently_forgot_password?
    MemberMailer.deliver_reset_password(member) if member.recently_reset_password?
  end
end
