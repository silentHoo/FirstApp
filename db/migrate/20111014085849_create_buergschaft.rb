class CreateBuergschaft < ActiveRecord::Migration
  def self.up
    create_table(:Buergschaft, :id => false) do |t|
      # Personalnummer Bürgschaft PS1, FS
      t.integer :pnrB, :null => false, :uniqueness => true, :limit => 10    
      # Mitgliedsnummer Gesellschafter PS2, FS
      t.integer :mnrG, :null => false, :uniqueness => true, :limit => 10   
      # Kontonummer FS
      t.integer :ktoNr, :null => false, :uniqueness => true, :limit => 5
      # SichAbDatum
      t.date :sichAbDatum, :default => nil
      # SichEndDatum
      t.date :sichEndDatum, :default => nil
      # SichBetrag
      t.decimal :sichBetrag, :scale => 2, :precision => 10, :default => nil
      # SichKurzBez
      t.string :sichKurzBez, :limit => 200, :default => nil    
    end
  end

  def self.down
    drop_table :Buergschaft
  end
end
