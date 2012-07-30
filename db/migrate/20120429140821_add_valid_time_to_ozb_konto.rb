class AddValidTimeToOzbKonto < ActiveRecord::Migration
  def change
    add_column :OZBKonto, :GueltigVon, :datetime
    add_column :OZBKonto, :GueltigBis, :datetime
  end
end
