class CreateGeschaeftsprozesses < ActiveRecord::Migration
  def up
    create_table :Geschaeftsprozesse do |t|
      t.string :Beschreibung
      t.boolean :IT
      t.boolean :MV
      t.boolean :RW
      t.boolean :ZW
      t.boolean :OeA

      t.timestamps
    end
  end
end
