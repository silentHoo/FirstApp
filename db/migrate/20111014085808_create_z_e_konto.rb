class CreateZEKonto < ActiveRecord::Migration
  def self.up
    create_table(:ZEKonto, :primary_key => :ktoNr) do |t|
      # Kontonummer PS, FS
      t.integer :ktoNr, :null => false, :uniqueness => true, :limit => 5
      # EEKtoNr FS
      t.integer :eeKtoNr, :null => false, :uniqueness => true, :limit => 5
      # Pgnr
      t.integer :pgNr, :limit => 2, :default => nil
      # zeNr
      t.string :zeNr, :limit => 10, :default => nil
      # zeAbDatum
      t.date :zeAbDatum, :default => nil
      # zeEndDatum
      t.date :zeEndDatum, :default => nil
      # zeBetrag
      t.decimal :zeBetrag, :scale => 2, :precision => 10, :default => nil
      # laufzeit
      t.integer :laufzeit, :null => false, :limit => 4
      # zahlModus
      t.string :zahlModus, :limit => 1, :default => 'M'
      # TilgRate
      t.decimal :tilgRate, :null => false, :scale => 2, :precision => 10, :default => 0.00
      # AnsparRate
      t.decimal :ansparRate, :null => false, :scale => 2, :precision => 10, :default => 0.00
      # KDURate
      t.decimal :kduRate, :null => false, :scale => 2, :precision => 10, :default => 0.00
      # RDURate
      t.decimal :rduRate, :null => false, :scale => 2, :precision => 10, :default => 0.00
      # ZEStatus
      t.string :zeStatus, :null => false, :limit => 1, :default => 'A'
    end
  end

  def self.down
    drop_table :ZEKonto
  end
end
