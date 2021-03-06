class CreateBuchungOnline < ActiveRecord::Migration
  def self.up
    create_table(:BuchungOnline, :primary_key => :id) do |t|
			#ID PS
			t.integer :id, :uniqueness => true, :limit => 10, :null => false
			#Mnr FS
      t.integer :mnr, :uniqueness => true, :limit => 10, :null => false
			#Überweisungsdatum
			t.date :ueberwdatum, :null => false
			#Soll Kontonummer
			t.integer :sollktonr, :limit => 5, :default => 0, :null => false
			#Haben Kontonummer
			t.integer :habenktonr, :limit => 5, :default => 0, :null => false
			#Punkte
			t.integer :punkte, :null => false, :limit => 10
			#Tan
			t.integer :tan, :null => false, :limit => 5
			#BlockNr
			t.integer :blocknr, :null => false, :limit => 2
    end
  end

  def self.down
    drop_table :BuchungOnline
  end
end
