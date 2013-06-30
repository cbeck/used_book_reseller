class AddFlagsToAccountType < ActiveRecord::Migration
  def self.up
    change_table :account_types do |t|
      t.boolean :enabled
      t.boolean :allow_signup
    end
  end

  def self.down
    change_table :account_types do |t|
      t.remove :enabled
      t.remove :allow_signup
    end
  end
end
