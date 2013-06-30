class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles", :force => true do |t|
      t.string :name
    end
    
    # generate the join table
    create_table "members_roles", :id => false do |t|
      t.integer "role_id", "member_id"
    end
    add_index "members_roles", "role_id"
    add_index "members_roles", "member_id"
  end

  def self.down
    drop_table "roles"
    drop_table "members_roles"
  end
end