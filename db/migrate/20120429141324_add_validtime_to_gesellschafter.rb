class AddValidtimeToGesellschafter < ActiveRecord::Migration
  def change
    add_column :Gesellschafter, :GueltigVon, :datetime
    add_column :Gesellschafter, :GueltigBis, :datetime
  end
end
