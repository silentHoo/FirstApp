class Tan < ActiveRecord::Base

  set_table_name "Tan"

  attr_accessible :mnr, :listNr, :tanNr, :tan, :verwendetAm, :status
  set_primary_keys :mnr, :listNr

  belongs_to :Tanliste # Done, getestet

end
