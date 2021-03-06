class CreateTan < ActiveRecord::Migration
  def self.up
    create_table(:Tan, :id => false) do |t|
       # Mitgliedsnummer PS1, FS
       t.integer :mnr, :null => false, :limit => 10    
       # Listennummer PS2, FS
       t.integer :listNr, :null => false, :limit => 2
       # Tannummer PS3
       t.integer :tanNr, :null => false, :limit => 10
       # Tan
       t.integer :tan, :null => false, :limit => 5
       # verwendet Am
       t.date :verwendetAm, :default => nil
       # status
			 t.column :status, "ENUM('o', 'x')" # o: offen, x: benutzt
    end
  end

  def self.down
    drop_table :Tan
  end
end
