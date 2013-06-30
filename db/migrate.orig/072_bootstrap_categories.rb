class BootstrapCategories < ActiveRecord::Migration
  def self.up
    execute "delete from categories_products" 
    execute "delete from categories"
    
    Category.create :name => "Religion / Devotional"
    Category.create :name => "Math"
    Category.create :name => "History"
    Category.create :name => "Literature"
    Category.create :name => "Language Arts"
    Category.create :name => "Grammar"
    Category.create :name => "Writing"
    Category.create :name => "Spelling"
    Category.create :name => "Reading"
    Category.create :name => "Foreign Languages"
    Category.create :name => "Science / Nature"
    Category.create :name => "Technology"
    Category.create :name => "Games / Toys"
    Category.create :name => "Unit Studies"
    Category.create :name => "Complete Curriculum"
    Category.create :name => "Teacher Resources / Encouragement"
    Category.create :name => "Miscellaneous"
    Category.create :name => "Art"
    Category.create :name => "Music"
    Category.create :name => "Business / Economics"
    Category.create :name => "Social Studies / Cultures"
    Category.create :name => "Health / Physical Education"
    Category.create :name => "Civics / Government"
  end

  def self.down
  end
end
