class CreateStudent < ActiveRecord::Migration
  def self.up
    create_table(:Student, :primary_key => :mnr) do |t|
      # Mitgliedsnummer PS, FS
      t.integer :mnr, :null => false, :uniqueness => true, :limit => 10
      # AusbildungsBezeichnung
      t.string :ausbildBez, :limit => 30, :default => nil
      # Institut
      t.string :institutName, :limit => 30, :default => nil
      # Studienort
      t.string :studienort, :limit => 30, :default => nil
      # Studienbeginn
      t.date :studienbeginn, :default => nil
      # Studienende
      t.date :studienende, :default => nil
      # Abschluss
      t.string :abschluss, :default => nil      
    end
  end

  def self.down
    drop_table :Student
  end
end
