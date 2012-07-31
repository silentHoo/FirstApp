class AddSachPnrToOzbPerson < ActiveRecord::Migration
  def change
    add_column :OZBPerson, :SachPNR, :integer
  end
end
