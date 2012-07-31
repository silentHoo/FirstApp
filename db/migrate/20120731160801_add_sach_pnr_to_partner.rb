class AddSachPnrToPartner < ActiveRecord::Migration
  def change
    add_column :Partner, :SachPNR, :integer
  end
end
