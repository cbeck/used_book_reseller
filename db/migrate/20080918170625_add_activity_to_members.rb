class AddActivityToMembers < ActiveRecord::Migration
  def self.up
    change_table :members do |t|
      t.string :last_activity
      t.datetime :last_activity_at
    end
  end

  def self.down
    change_table :members do |t|
      t.remove :last_activity
      t.remove :last_activity_at
    end
  end
end
