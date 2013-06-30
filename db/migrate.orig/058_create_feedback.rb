class CreateFeedback < ActiveRecord::Migration
  def self.up
    create_table :feedback do |t|
      t.column :feedback, :text
      t.column :line_item_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :feedback
  end
end
