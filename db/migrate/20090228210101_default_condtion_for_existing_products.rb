class DefaultCondtionForExistingProducts < ActiveRecord::Migration
  def self.up
    condition = Condition.find_by_name('like_new')
    Product.update_all("condition_id = #{condition.id}")
  end

  def self.down
  end
end
