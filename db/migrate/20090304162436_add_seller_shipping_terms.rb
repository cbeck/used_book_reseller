class AddSellerShippingTerms < ActiveRecord::Migration
  def self.up
    change_table :sellers do |t|
      t.integer :shipping_term_id
    end  
    
    Seller.reset_column_information
    
    ship_term = ShippingTerm.find_by_name('3-5 days')
    sellers = Seller.update_all "shipping_term_id=#{ship_term.id}"
  end

  def self.down
    change_table :sellers do |t|
      t.remove :shipping_term_id
    end
  end
end
