class AddSachPnrToOzbKonto < ActiveRecord::Migration
  def change
    add_column :OZBKonto, :SachPNR, :integer
  end
end
