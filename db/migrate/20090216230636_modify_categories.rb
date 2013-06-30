class ModifyCategories < ActiveRecord::Migration
  def self.up
    phys_ed = Category.find_by_name("Health / Physical Education")
    phys_ed.update_attribute(:name, "Health / Phys. Ed.") unless phys_ed.nil?
    
    teach_res = Category.find_by_name("Teacher Resources / Encouragement")
    unless teach_res.nil?
      teach_res.update_attribute(:name, "Teacher Resources")
      Category.create(:name => "Teacher Encouragement")
    end
  end

  def self.down
    #nichts machen
  end
end
