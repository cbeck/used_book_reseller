class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.column "name", :string
      t.column "description", :text
      t.column "active", :boolean
    end
  end

  def self.down
    drop_table :profiles
  end
end
