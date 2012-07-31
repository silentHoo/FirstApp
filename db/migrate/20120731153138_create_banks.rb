class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.integer :BLZ
      t.string :BIC
      t.string :BankName

      t.timestamps
    end
  end
end
