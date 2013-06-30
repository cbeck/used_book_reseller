class ModifyRatings < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    create_table :ratings do |t|
      t.column :name, :string
      t.column :score, :integer
    end
    
    foreign_key(:product_reviews, :rating_id, :ratings)
  end

  def self.down
    drop_table :ratings
    
  end
end
