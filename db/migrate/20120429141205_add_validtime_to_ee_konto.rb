class AddValidtimeToEeKonto < ActiveRecord::Migration
  def change
    add_column :EEKonto, :GueltigVon, :datetime
    add_column :EEKonto, :GueltigBis, :datetime
  end
end
