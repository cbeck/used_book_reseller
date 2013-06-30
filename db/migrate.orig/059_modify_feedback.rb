class ModifyFeedback < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    change_column :feedback, :feedback, :string
    add_column :feedback, :comment, :text
    
    foreign_key(:feedback, :line_item_id, :line_items)    
  end

  def self.down
    remove_column :feedback, :comment
    change_column :feedback, :feedback, :text
  end
end
