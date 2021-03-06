class CreateTelefon < ActiveRecord::Migration
  def self.up
    create_table(:Telefon, :primary_key => :lfdNr) do |t|
      # Personalnummer PS1, FS
      t.integer :pnr, :null => false, :limit => 10
      # Laufende Nummer PS2
      t.integer :lfdNr, :null => false, :uniqueness => true, :limit => 2
      # Telefonnummer
      t.string :telefonNr, :limit => 15
      # Telefontyp
      t.string :telefonTyp, :limit => 6
    end
  end

  def self.down
    drop_table :Telefon
  end
end
