class AddValidtimeToZeKonto < ActiveRecord::Migration
  def change
    add_column :ZEKonto, :GueltigVon, :datetime
    add_column :ZEKonto, :GueltigBis, :datetime
  end
end
