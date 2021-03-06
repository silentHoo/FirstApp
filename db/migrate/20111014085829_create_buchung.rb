class CreateBuchung < ActiveRecord::Migration
  def self.up
    create_table(:Buchung, :id => false) do |t|
    # Buchungsjahr PS1
    t.integer :buchJahr, :null => false, :limit => 4
    # Kontonummer PS2, FS
    t.integer :ktoNr, :null => false, :limit => 5
    # BnKreis PS3
		t.string :bnKreis, :null => false, :limit => 2
		# BelegNr PS4
		t.integer :belegNr, :null => false, :limit => 10 
		# Typ PS5
		t.string :typ, :null => false, :limit => 1
		# BelegDatum
		t.date :belegDatum, :null => false
		# Buchungsdatum
		t.date :buchDatum, :null => false
		# Buchungstext
		t.string :buchungstext, :null => false, :limit => 50
		# SollBetrag
		t.decimal :sollBetrag, :scale => 2, :precision => 10, :default => nil
		# HabenBetrag
		t.decimal :habenBetrag, :scale => 2, :precision => 10, :default => nil
		# SollKontoNummer
		t.integer :sollKtoNr, :null => false, :limit => 5, :default => 0
		# HabenKontoNummer
		t.integer :habenKtoNr, :null => false, :limit => 5, :default => 0
		# WSaldoAccount
		t.decimal :wSaldoAcc, :null => false, :scale => 2, :precision => 10, :default => 0.00
		# Punkte
		t.integer :punkte, :limit => 10, :default => nil
		# PSaldoAccount
		t.integer :pSaldoAcc, :null => false, :limit => 10, :default => 0
    end
  end

  def self.down
    drop_table :Buchung
  end
end
