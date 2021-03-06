class CreateMitglied < ActiveRecord::Migration
  def self.up
    create_table(:Mitglied, :primary_key => :mnr) do |t|
      # Mitgliedsnummer, PS, FS
      t.integer :mnr, :null => false, :uniqueness => true, :limit => 10, :primary => true
      # RVDatum
      t.date :rvDatum, :default => nil
    end
  end

  def self.down
    drop_table :Mitglied
  end
end
