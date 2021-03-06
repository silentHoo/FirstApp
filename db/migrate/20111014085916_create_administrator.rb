class CreateAdministrator < ActiveRecord::Migration
  def self.up
    create_table(:Administrator, :primary_key => :pnr) do |t|
      # Index
      t.integer :pnr, :null => false, :uniqueness => true, :limit => 10
      #AdminPW
      t.string :adminPw, :null => false, :limit => 35
      # E-Mail
      t.string :adminEmail, :default => nil
    end
  end

  def self.down
    drop_table :Administrator
  end
end
