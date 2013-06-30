class AddFlagsToSeller < ActiveRecord::Migration
  def self.up
    change_table :sellers do |t|
      t.boolean :accepted_terms
      t.string  :preferred_payment_method
    end
  end

  def self.down
    change_table :sellers do |t|
      t.remove :accepted_terms
      t.remove  :preferred_payment_method
    end
  end
end
