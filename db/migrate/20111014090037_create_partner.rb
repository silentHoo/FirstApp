class CreatePartner < ActiveRecord::Migration
  def self.up
    create_table(:Partner, :primary_key => :mnr) do |t|
      # Mitgliedsnummer PS
      t.integer :mnr, :null => false, :uniqueness => true, :limit => 10
      # MnrO FS
      t.integer :mnrO, :null => false, :uniqueness => true, :limit => 10
      # Berechtigung
      t.string :berechtigung, :null => false, :limit => 1
    end
  end

  def self.down
    drop_table :Partner
  end
end
