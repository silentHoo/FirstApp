class OzbPerson < ActiveRecord::Base
   
   attr_accessible :mnr, :ueberPnr, :passwort, :pwAendDatum, :gesperrt

end