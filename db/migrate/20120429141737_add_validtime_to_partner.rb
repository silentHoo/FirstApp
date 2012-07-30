class AddValidtimeToPartner < ActiveRecord::Migration
  def change
    add_column :Partner, :GueltigVon, :datetime
    add_column :Partner, :GueltigBis, :datetime
  end
end
