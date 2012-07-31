class Mitglied < ActiveRecord::Base

  set_table_name "Mitglied"
  set_primary_key :mnr

  attr_accessible :mnr, :rvDatum

  belongs_to :ozb_person
  
end
