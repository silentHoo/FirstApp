class CreateOzbPeople < ActiveRecord::Migration
  def self.up
    create_table (:ozb_people, :primary_key => :mnr) do |t|
      # Mitgliedsnummer PS, FS
      t.integer :mnr, :presence => true, :uniqueness => true, :length => {:maximum => 10 }
      # Personennummer FS
      t.integer :ueberPnr, :uniqueness => true, :length => {:maximum => 10 }
      # Passwort
      t.string :passwort, :length => {:maximum => 35 }
      # PWAendDatum
      t.date :pwAendDatum
      # Gesperrt
      t.boolean :gesperrt, :presence => true
    end
  end

  def self.down
    drop_table :ozb_people
  end
end