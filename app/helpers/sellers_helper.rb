module SellersHelper
  
  def render_seller_rating(seller)
    output = "This seller has not received any feedback yet."
    unless seller.feedback_rating.blank? 
      output = "Average feedback rating #{seller.feedback_rating} out of 5. "
      output += link_to "See all.", feedback_seller_path(seller)
    end
    output
  end
  
end