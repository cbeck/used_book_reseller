class PaymentNotificationObserver < ActiveRecord::Observer
  def after_create(pn)

    pn.order.update_attributes(
      :name => "#{pn.params[:first_name]} #{pn.params[:last_name]}",
      :email => pn.params[:payer_email],
      :address_line_1 => pn.params[:address_street],
      :city => pn.params[:address_city],
      :state => pn.params[:address_state],
      :zip => pn.params[:address_zip],
      :country => pn.params[:address_country_code]
    )
    
    case pn.params[:payment_status]
    when "Completed"
      if pn.params[:mc_gross] == pn.order.total_price.to_s &&
         pn.params[:receiver_email] == APP_CONFIG[:paypal_email] &&
         pn.params[:secret] == APP_CONFIG[:paypal_secret]
        
        pn.order.payment_received!
      else
        pn.order.cancel!
        MemberMailer.deliver_fraud_alert(pn)
      end
    else
      pn.order.unknown_status!
    end

    MemberMailer.deliver_admin_payment_notify(pn)
    
  end
end
