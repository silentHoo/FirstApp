class AddSachPnrToZeKonto < ActiveRecord::Migration
  def change
    add_column :ZeKonto, :SachPNR, :integer
  end
end
