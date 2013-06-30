class AddSessionToOrders < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.string :session_id
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove :session_id
    end
  end
end
