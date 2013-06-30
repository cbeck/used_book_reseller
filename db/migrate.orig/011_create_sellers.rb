class CreateSellers < ActiveRecord::Migration
  def self.up
    create_table :sellers do |t|
      t.column :name, :string
      t.column :address_line_1, :string
      t.column :address_line_2, :string
      t.column :city, :string
      t.column :state, :string, :limit => 20
      t.column :zip, :string, :limit => 10
      t.column :country, :string, :limit => 50
      t.column :email, :string, :limit => 80, :null => false
      t.column :super_user_id, :integer
      t.column :phone, :string, :limit => 30
      t.column :pay_pal_id, :string
      t.column :merchant_id, :string
      t.column :image, :binary
    end
  end

  def self.down
    drop_table :sellers
  end
end
