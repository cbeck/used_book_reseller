class PaymentNotificationsController < ApplicationController
  skip_before_filter [:login_from_cookie, :find_cart, :find_featured]
  protect_from_forgery :except => [:create]
  ssl_required :create
  
  def create
    pmt = PaymentNotification.create!(:params => params, :order_id => params[:invoice], 
        :status => params[:payment_status], :transaction_id => params[:txn_id])
    render :nothing => true
  end
end
