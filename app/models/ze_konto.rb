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
  # validate always things you will accept nested attributes for!
  validates :ktoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Kontonummer an." }
  validates :eeKtoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige EE-Kontonummer an." }
  validates :pgNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Projektgruppe an." }
  validates :zeNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige ZE-Kontonummer an." }
  validates :laufzeit, :presence => { :format => { :with => /[1-9]+/ }, :message => "Bitte geben Sie eine gültige Laufzeit an." }
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :ktoNr => 'Konto-Nr.',
    :eeKtoNr => 'EE Konto-Nr.',
    :pgNr => 'Projekt',
    :zeNr => 'ZE-Nr.',
    :zeAbDatum => 'Gültig ab',
    :zeEndDatum => 'Gültig bis',
    :zeBetrag => 'Betrag',
    :laufzeit => 'Laufzeit',
    :zahlModus => 'Zahlungsmodus',
    :tilgRate => 'Tilgungsrate',
    :ansparRate => 'Ansparrate',
    :kduRate => 'KDU-Rate',
    :rduRate => 'RDU-Rate',
    :zeStatus => 'Status'
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
    if(self.ktoNr)
      if(self.GueltigBis > "9999-01-01 00:00:00")
        copy = self.get(self.ktoNr)
        copy = copy.dup
        copy.KtoNr = self.ktoNr
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
    self.find(:all, :conditions => ["ktoNr = ? AND GueltigVon <= ? AND GueltigBis > ?", ktoNr, date, date]).first
  end
end
