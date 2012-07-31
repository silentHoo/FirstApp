class AddSachPnrToPerson < ActiveRecord::Migration
  def change
    add_column :Person, :SachPNR, :integer
  end
end
