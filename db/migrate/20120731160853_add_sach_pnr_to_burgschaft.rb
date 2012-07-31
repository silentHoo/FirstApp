class AddSachPnrToBurgschaft < ActiveRecord::Migration
  def change
    add_column :Buergschaft, :SachPNR, :integer
  end
end
