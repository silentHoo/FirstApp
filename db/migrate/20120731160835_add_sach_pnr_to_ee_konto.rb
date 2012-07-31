class AddSachPnrToEeKonto < ActiveRecord::Migration
  def change
    add_column :EEKonto, :SachPNR, :integer
  end
end
