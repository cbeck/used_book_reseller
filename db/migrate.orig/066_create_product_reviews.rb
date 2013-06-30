class CreateProductReviews < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :product_reviews do |t|
      t.column :isbn, :string
      t.column :name, :string
      t.column :author, :string
      t.column :publisher, :string
      t.column :content, :text
      t.column :user_id, :integer
      t.column :created_at, :timestamp
      t.column :rating_id, :integer
    end
    
    foreign_key(:product_reviews, :user_id, :users)
    
  end

  def self.down
    drop_table :product_reviews
  end
end
