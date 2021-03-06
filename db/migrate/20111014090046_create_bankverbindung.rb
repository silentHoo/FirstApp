class CreateBankverbindung < ActiveRecord::Migration
  def self.up
    create_table(:Bankverbindung) do |t|
      # Personalnummer FS
      t.integer :pnr, :null => false, :uniqueness => true, :limit => 10
      # BankKtoNr
      t.string :bankKtoNr, :limit => 10, :default => nil
      # Bankleitzahl
      t.integer :blz, :limit => 10, :default => nil
      # BIC
      t.string :bic, :limit => 10, :default => nil
      # IBAN
      t.string :iban, :limit => 20, :default => nil
      # Bankenname
      t.string :bankName, :limit => 35, :default => nil      
    end
  end

  def self.down
    drop_table :Bankverbindung
  end
end
