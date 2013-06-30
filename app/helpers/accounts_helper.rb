module AccountsHelper
  
  def render_account_feature_content(account_type, account_feature)
    has_it = account_feature.account_types.include? account_type
    output = ""
    output += case account_feature.name
      when "yearly_sales_limit_lifted" : (has_it) ? "Unlimited" : "Unlimited during Beta<br/>(3 afterwards)" #account_type.max_products.to_s
      when "listing_fees" : (has_it) ? "None" : account_type.flat_fee.to_s 
      when "sold_item_fees" : (has_it) ? "None" : "None during test period<br/>(3% afterwards)"#account_type.commission.to_s   
      when "allow_uploads" : (has_it) ? "Yes, with 2% commission" : ""
      when "bypass_inventory_management" : (has_it) ? "Yes, with 2% commission" : ""
      else (has_it) ? image_tag("tick.png") : ""  
    end
    output
  end
    
end