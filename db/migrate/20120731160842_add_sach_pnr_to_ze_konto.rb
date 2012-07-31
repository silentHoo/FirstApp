class AddSachPnrToZeKonto < ActiveRecord::Migration
  def change
    add_column :ZEKonto, :SachPNR, :integer
  end
end
