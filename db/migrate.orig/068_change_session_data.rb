class ChangeSessionData < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `sessions` CHANGE `data` `data` longtext DEFAULT NULL"
  end

  def self.down
  end
end
