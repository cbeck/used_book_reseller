class AddPasswordResetToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :password_reset_code, :string, :limit => 40
    add_column :members, :password_reset_at, :datetime
  end

  def self.down
    remove_column :members, :password_reset_at
    remove_column :members, :password_reset_code
  end
end
