class CreateAdministrators < ActiveRecord::Migration
  def self.up
    create_table (:administrators, :primary_key => :pnr) do |t|
      # Index
      t.integer :pnr, :presence => true, :uniqueness => true, :length => {:maximum => 10}
      #AdminPW
      t.string :adminPw, :presence => true, :length => {:maximum =>35}
      # E-Mail
      t.string :adminEmail
    end
  end

  def self.down
    drop_table :administrators
  end
end