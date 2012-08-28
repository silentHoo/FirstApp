class Gesellschafter < ActiveRecord::Base

  set_table_name "Gesellschafter"
  
  self.primary_keys = :mnr, :GueltigBis
  
  attr_accessible :mnr, :faSteuerNr, :faLfdNr, :wohnsitzFinanzamt, :notarPnr, :beurkDatum
  
  validates_presence_of :faSteuerNr, :faLfdNr, :wohnsitzFinanzamt

  belongs_to :ozb_person, :class_name => "OzbPerson", :foreign_key => :mnr
  
  def fullname
    if (!self.ozb_person.nil?)
      if (!self.ozb_person.person.nil?)
        return self.ozb_person.person.fullname
      end
    end
  end
  
  def self.latest(mnr)
    self.find(mnr, "9999-12-31 23:59:59")
  end
  
  def self.latest_all
    self.find(:all, :conditions => { :GueltigBis => "9999-12-31 23:59:59" })
  end
end
