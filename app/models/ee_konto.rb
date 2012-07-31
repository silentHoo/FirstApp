# encoding: UTF-8
class EEKonto < ActiveRecord::Base
  set_table_name "EEKonto"
  set_primary_key :ktoNr
  
  # attributes
  attr_accessible :ktoNr, :bankId, :kreditlimit

  # associations
  belongs_to :OZBKonto, :foreign_key => :ktoNr
  belongs_to :Bankverbindung, :foreign_key => :id
  has_one :ZEKonto, :foreign_key => :ktoNr # Done, getestet
  
  # validations
  validates_associated :Bankverbindung
  validates :ktoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Kontonummer an." }
  validates :ktoNr, :uniqueness => { :message => "Diese Kontonummer exisitert bereits für ein EE-Konto." }
  validates :kreditlimit, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie ein gültiges Kreditlimit ein." }
  validates :GueltigVon, :presence => { :format => { :with => /\d{4}-\d{2}-\d{2}/ }, :message => "Bitte geben Sie ein gültiges Startdatum ein." }
  validates :GueltigBis, :presence => { :format => { :with => /\d{4}-\d{2}-\d{2}/ }, :message => "Bitte geben Sie ein gültiges Enddatum ein." }
  validate :valid_date_range
  
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
  
  def valid_date_range
	if GueltigVon < GueltigBis then
	  errors.add(:GueltigBis, "Das Enddatum muss nach dem Startdatum liegen.")
	end
	
	if self.find(:ktoNr => ktoNr, :conditions => { :GueltigVon_gte => GueltigVon, :GueltigBis_lte => GueltigBis }).size > 0 then
	  errors.add(:GueltigVon, "Der angegebene Datumsbereich überlappt sich mit bereits vorhandenen Daten.")
	end
  end
end