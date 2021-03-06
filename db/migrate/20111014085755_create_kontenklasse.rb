class CreateKontenklasse < ActiveRecord::Migration
  def self.up
    create_table(:Kontenklasse, :primary_key => :kkl) do |t|
      # Kontoklasse PS
      t.integer :kkl, :null => false, :uniqueness => true, :limit => 1
      # KKLAbDatum
      t.date :kklAbDatum, :null => false
      # Prozent
      t.decimal :prozent, :null => false, :scale => 2, :precision => 5, :default => 0.00
    end
  end

  def self.down
    drop_table :Kontenklasse
  end
end
