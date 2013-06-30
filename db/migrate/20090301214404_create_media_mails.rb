class CreateMediaMails < ActiveRecord::Migration
  def self.up
    create_table :media_mails do |t|
      t.integer :factor, :default => 35
      t.integer :starting_point, :default => 188
      t.string :currency, :limit=>3, :default=>"USD"

      t.timestamps
    end
    
    MediaMail.create(:factor => 35, :starting_point => 188)
  end

  def self.down
    drop_table :media_mails
  end
end
