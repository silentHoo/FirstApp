class CreateVeranstaltungsart < ActiveRecord::Migration
  def self.up
    create_table(:Veranstaltungsart, :primary_key => :id) do |t|
      # Veranstaltungsart-id PS
      t.integer :id, :null => false, :uniqueness => true, :limit => 2
      # VABezeichnung
      t.string :vaBezeichnung, :limit => 30, :default => nil
      
    end
  end

  def self.down
    drop_table :Veranstaltungsart
  end
end
