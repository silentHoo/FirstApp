class AddValidtimeToPerson < ActiveRecord::Migration
  def change
    add_column :Person, :GueltigVon, :datetime
    add_column :Person, :GueltigBis, :datetime
  end
end
