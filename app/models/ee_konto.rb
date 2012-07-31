# encoding: UTF-8
class EEKonto < ActiveRecord::Base
  set_table_name "EEKonto"
  set_primary_keys :ktoNr, :GueltigBis
  
  # attributes
  attr_accessible :ktoNr, :bankId, :kreditlimit
  alias_attribute :ktoNr, :KtoNr
  alias_attribute :bankId, :BankId
  alias_attribute :kreditlimit, :Kreditlimit

  # associations
  belongs_to :OZBKonto, :foreign_key => :ktoNr
  belongs_to :Bankverbindung, :foreign_key => :id
  has_one :ZEKonto, :foreign_key => :ktoNr # Done, getestet
  
  has_one :sachbearbeiter, :class_name => "Person", :foreign_key => :Pnr, :primary_key => :SachPNR, :order => "GueltigBis DESC"
  
  # validations
  validates_associated :Bankverbindung
  validates :ktoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Kontonummer an." }
  validates :ktoNr, :uniqueness => { :message => "Diese Kontonummer exisitert bereits für ein EE-Konto." }
  validates :kreditlimit, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie ein gültiges Kreditlimit ein." }
  validates :GueltigVon, :presence => { :format => { :with => /\d{4}-\d{2}-\d{2}/ }, :message => "Bitte geben Sie ein gültiges Startdatum ein." }
  validates :GueltigBis, :presence => { :format => { :with => /\d{4}-\d{2}-\d{2}/ }, :message => "Bitte geben Sie ein gültiges Enddatum ein." }
  
  # callbacks
  before_save :set_valid_time
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :ktoNr => 'Konto-Nr.',
    :bankId => 'Bank-ID',
    :kreditlimit => 'Kreditlimit',
	:GueltigVon => 'Gültig von',
	:GueltigBis => 'Gültig bis'
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
        copy = EEKonto.get(self.KtoNr)
        copy = copy.dup
        copy.KtoNr = self.KtoNr
        copy.GueltigVon = self.GueltigVon
        copy.GueltigBis = Time.now      
        copy.save!
        puts self.inspect
        puts "---"
        self.GueltigVon = Time.now      
        self.GueltigBis = Time.zone.parse("9999-12-31 23:59:59")      
        puts self.inspect
        puts "---"
      end
    end
  end

  # Returns nil if at the given time no person object was valid
  def EEKonto.get(ktoNr, date = Time.now)
    EEKonto.where(:KtoNr => ktoNr).where(["GueltigVon <= ?", date]).where(["GueltigBis > ?",date]).first
  end
end