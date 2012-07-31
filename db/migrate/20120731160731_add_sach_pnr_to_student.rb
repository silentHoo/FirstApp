class AddSachPnrToStudent < ActiveRecord::Migration
  def change
    add_column :Student, :SachPNR, :integer
  end
end
