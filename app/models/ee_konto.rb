# encoding: UTF-8
class EeKonto < ActiveRecord::Base
  self.table_name = "eekonto"
  self.primary_keys = :ktoNr, :GueltigBis # two primary keys define an unique record
  
  # associations
  belongs_to :ozb_konto,
    :primary_key => :ktoNr, 
    :foreign_key => :ktoNr, 
    :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
    
  belongs_to :bankverbindung, 
    :foreign_key => :bankId, 
    :class_name => "Bankverbindung", 
    :autosave => true, 
    :dependent => :destroy
    
  has_one :ze_konto, 
    :foreign_key => :ktoNr, 
    :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
    
  belongs_to :sachbearbeiter, 
    :class_name => "Person", 
    :foreign_key => :Pnr, 
    :primary_key => :SachPNR, 
    :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
  
  # attributes
  # accept only and really only attr_accessible if you want that a user is able to mass-assign these attributes!
  accepts_nested_attributes_for :bankverbindung
  attr_accessible :ktoNr, :bankId, :kreditlimit, :bankverbindung_attributes, :sachbearbeiter_attributes
  
  # validations
  # validate always things you will accept nested attributes for!
  validates :ktoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Kontonummer an." }
  validates_associated :bankverbindung
  validate :valid_one_bankverbindung_given?
  validates :kreditlimit, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie ein gültiges Kreditlimit ein." }
  # GueltigVon und GueltigBis wird durch Model selbst gesetzt
  # Sachbearbeiter muss durch Controller oder abhängiges Model gesetzt werden!
  
  # callbacks
  before_create :set_valid_time
  before_update :set_new_valid_time
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :ktoNr        => 'Konto-Nr.',
    :bankId       => 'Bank-ID',
    :kreditlimit  => 'Kreditlimit',
    :GueltigVon   => 'Gültig von',
    :GueltigBis   => 'Gültig bis'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def valid_one_bankverbindung_given?
    errors.add(:bankverbindung, "Keine Bankverbindung angegeben.") if self.bankverbindung.nil?
  end
  
  # bound to callback
  def set_valid_time
    unless(self.GueltigBis || self.GueltigVon)
      self.GueltigVon = Time.now
      self.GueltigBis = Time.zone.parse("9999-12-31 23:59:59")
    end
  end
  
  # bound to callback
  def set_new_valid_time
    if (self.ktoNr)
      if (self.GueltigBis > "9999-01-01 00:00:00")
        copy = self.get(self.ktoNr)
        copy = copy.dup
        copy.ktoNr = self.ktoNr
        copy.GueltigVon = self.GueltigVon
        copy.GueltigBis = Time.now
        copy.save!
        
        self.GueltigVon = Time.now
        self.GueltigBis = Time.zone.parse("9999-12-31 23:59:59")
      end
    end
  end
 
  # Returns the EEKonto Object for ktoNr and date
  def get(ktoNr, date = Time.now)
    self.find(:all, :conditions => ["ktoNr = ? AND GueltigVon <= ? AND GueltigBis > ?", ktoNr, date, date]).first
  end
end