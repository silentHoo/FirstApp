# encoding: UTF-8
class ZeKonto < ActiveRecord::Base
  self.table_name = "zekonto"
  self.primary_keys = :ktoNr, :GueltigBis

  # attributes
  attr_accessible :ktoNr, :eeKtoNr, :pgNr, :zeNr, :zeAbDatum, :zeEndDatum, :zeBetrag, 
                  :laufzeit, :zahlModus, :tilgRate, :ansparRate, :kduRate, :rduRate, :zeStatus
  
  # associations
  belongs_to :ozb_konto, :foreign_key => :ktoNr, :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
  belongs_to :ee_konto, :foreign_key => :eeKtoNr, :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
  has_many :buergschaft, :foreign_key => :ktoNr # no one or many; Done, getestet
  belongs_to :projektgruppe, :inverse_of => :ZEKonto, :foreign_key => :pgNr # Done, getestet
  has_one :sachbearbeiter, :class_name => "Person", :foreign_key => :Pnr, :primary_key => :SachPNR, :order => "GueltigBis DESC", :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
  
  # validations
  # ...
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :ktoNr => 'Konto-Nr.',
    :eeKtoNr => 'EE Konto-Nr.',
    :pgNr => 'pgNr',
    :zeNr => 'zeNr',
    :zeAbDatum => 'Gültig ab',
    :zeEndDatum => 'Gültig bis',
    :zeBetrag => 'zeBetrag',
    :laufzeit => 'Laufzeit',
    :zahlModus => 'zahlModus',
    :tilgRate => 'Tilgungsrate',
    :ansparRate => 'Ansparrate',
    :kduRate => 'kduRate',
    :rduRate => 'rduRate',
    :zeStatus => 'zeStatus'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  before_save do
    unless(self.GueltigBis || self.GueltigVon)
      self.GueltigVon = Time.now
      self.GueltigBis = Time.zone.parse("9999-12-31 23:59:59")
    end
  end

  before_update do
    if(self.KtoNr)
      if(self.GueltigBis > "9999-01-01 00:00:00")
        copy = self.get(self.KtoNr)
        copy = copy.dup
        copy.KtoNr = self.KtoNr
        copy.GueltigVon = self.GueltigVon
        copy.GueltigBis = Time.now
        copy.save!
        self.GueltigVon = Time.now
        self.GueltigBis = Time.zone.parse("9999-12-31 23:59:59")
      end
    end
  end

  # Returns nil if at the given time no person object was valid
  def get(ktoNr, date = Time.now)
    self.where(:KtoNr => ktoNr).where(["GueltigVon <= ?", date]).where(["GueltigBis > ?",date]).first
  end 
end
