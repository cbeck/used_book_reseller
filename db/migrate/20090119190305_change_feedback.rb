class ChangeFeedback < ActiveRecord::Migration
  def self.up
    change_table :feedback do |t|
      t.remove :feedback
      t.integer :rating
    end
  end

  def self.down
    change_table :feedback do |t|
      t.remove :rating
      t.string :feedback
    end 
  end
end
