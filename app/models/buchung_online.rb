class BuchungOnline < ActiveRecord::Base

  set_table_name "BuchungOnline"
  
  set_primary_key :id

  attr_accessible :id, :mnr, :ueberwdatum, :sollktonr, :habenktonr, :punkte, :tan, :blocknr
  
  belongs_to :OZBPerson
end
