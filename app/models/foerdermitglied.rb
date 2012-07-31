class Foerdermitglied < ActiveRecord::Base

   set_table_name "Foerdermitglied"
   set_primary_key :pnr

   attr_accessible :pnr, :region, :foerderbeitrag
   
   validates_presence_of :region, :foerderbeitrag

end
