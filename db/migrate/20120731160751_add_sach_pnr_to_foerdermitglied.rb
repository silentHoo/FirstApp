class AddSachPnrToFoerdermitglied < ActiveRecord::Migration
  def change
    add_column :Foerdermitglied, :SachPNR, :integer
  end
end
