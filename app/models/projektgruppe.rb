class Projektgruppe < ActiveRecord::Base

  set_table_name "Projektgruppe"

  set_primary_key :pgNr
  
  attr_accessible :pgNr, :projGruppez
  
  has_many :ZEKonto, :inverse_of => :Projektgruppe, :foreign_key => :pgNr # Done, getestet

end
