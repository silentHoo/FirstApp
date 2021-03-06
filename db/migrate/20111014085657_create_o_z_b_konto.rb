class CreateOZBKonto < ActiveRecord::Migration
  def self.up
    create_table(:OZBKonto, :primary_key => :ktoNr) do |t| 
      # KtoNr PS
      t.integer :ktoNr, :null => false, :uniqueness => true, :limit => 5
      # Mitgliedsnummer FS
      t.integer :mnr, :null => false, :uniqueness => true, :limit => 10
      # Kontoeinrichtungsdatum
      t.date :ktoEinrDatum
      # Waehrung
      t.string :waehrung, :limit => 3, :default => "STR"
      # WSaldo
      t.decimal :wSaldo, :scale => 2, :precision => 10, :default => nil
      # PSaldo
      t.integer :pSaldo, :limit => 11
      # SaldoDatum
      t.date :saldoDatum
    end
  end

  def self.down
    drop_table :OZBKonto
  end
end
