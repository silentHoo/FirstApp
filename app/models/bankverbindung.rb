# encoding: UTF-8
class Bankverbindung < ActiveRecord::Base
  set_table_name "Bankverbindung"
  set_primary_key :id
  
  # attributes
  attr_accessible :id, :pnr, :bankKtoNr, :blz, :bic, :iban, :bankName   

  # associations
  belongs_to :Person, :foreign_key => :pnr
  has_one :EEKonto, :foreign_key => :bankId # Done, getestet
  
  # validations
  validates :bankKtoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Bankkonto-Nummer an (nur Zahlen 0-9)." }
  validates :blz, :presence => { :message => "Bitte geben Sie eine BLZ an (oder stattdessen IBAN und BIC)", :if => "(iban.nil? or iban.to_s.empty?) and (bic.nil? or bic.to_s.empty?)" }
  validates :blz, :presence => { :format => { :with => /[0-9]+/ }, :if => "!blz.nil? and !blz.to_s.empty?", :message => "Bitte geben Sie eine numerische BLZ an" }
  validates :iban, :presence => { :message => "Bitte geben Sie die IBAN an", :if => "blz.nil? or blz.to_s.empty?" }
  validates :bic, :presence => { :message => "Bitte geben Sie die BIC an", :if => "blz.nil? or blz.to_s.empty?" }
  validates :bankName, :presence => { :message => "Bitte geben Sie den Banknamen an" }
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :id => 'ID',
    :pnr => 'Personen-Nr.',
    :bankKtoNr => 'Kontonummer',
    :blz => 'BLZ',
	:bic => 'BIC',
	:iban => 'IBAN',
	:bankName => 'Name der Bank'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
