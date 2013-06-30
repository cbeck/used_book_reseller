class AddAttributesToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.integer :member_id
      t.string :city 
      t.string :state 
      t.string :zip 
      t.string :gender 
      t.string :birth_month 
      t.string :birth_day 
      t.string :educational_philosophy 
      t.string :curriculum 
      t.string :primary_motivation 
      t.string :strengths 
      t.string :current_grade_levels 
      t.string :number_of_children 
      t.string :ages_of_children 
      t.string :genders_of_children 
      t.string :primary_teacher 
      t.string :blog_url
      t.string :flickr_url
      t.string :you_tube_url
      t.timestamps
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :member_id
      t.remove :city 
      t.remove :state 
      t.remove :zip 
      t.remove :gender 
      t.remove :birth_month 
      t.remove :birth_day 
      t.remove :educational_philosophy 
      t.remove :curriculum 
      t.remove :primary_motivation 
      t.remove :strengths 
      t.remove :current_grade_levels 
      t.remove :number_of_children 
      t.remove :ages_of_children 
      t.remove :genders_of_children 
      t.remove :primary_teacher 
      t.remove :blog_url
      t.remove :flickr_url
      t.remove :you_tube_url
    end
  end
end
