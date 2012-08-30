class CreateSonderberechtigungs < ActiveRecord::Migration
  def change
    create_table :Sonderberechtigung do |t|
      t.integer :Mnr
      t.string :Email
      t.column :Berechtigung, "ENUM('IT','MV','RW','ZE','OeA')"
      
      t.timestamps
    end
  end
end
