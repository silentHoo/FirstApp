class AddValidtimeToFoerdermitglied < ActiveRecord::Migration
  def change
    add_column :Foerdermitglied, :GueltigVon, :datetime
    add_column :Foerdermitglied, :GueltigBis, :datetime
  end
end
