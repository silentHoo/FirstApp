class CreateAdresses < ActiveRecord::Migration
  def change
    create_table(:Adresse, :primary_key => :Pnr) do |t|
      t.integer :Pnr
      t.string :Strasse
      t.integer :Nr
      t.integer :PLZ
      t.string :Ort
      t.datetime :GueltigVon
      t.datetime :GueltigBis

      t.timestamps
    end
  end
end
