class RenameImageToData < ActiveRecord::Migration
  def self.up
    rename_column :products, :image, :data
  end

  def self.down
    # no drop -  this change is needed for FlexImage to work (has data= method)
  end
end
