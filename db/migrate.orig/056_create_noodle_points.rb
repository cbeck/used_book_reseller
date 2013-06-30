class CreateNoodlePoints < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    #drop_table :opinions
    
    create_table :points do |t|
      t.column "user_id", :integer
      t.column "rating_id", :integer
      t.column "feedback", :text
      t.column "created_at", :datetime
      t.column "created_by", :integer
      t.column "line_item_id", :integer
    end
    
    foreign_key(:points, :user_id, :users)
    foreign_key(:points, :line_item_id, :line_items)
    execute "alter table points
      add constraint fk_created_by_points
      foreign key (created_by) references users(id)"    
  end

  def self.down
    drop_table :points
  end

end
