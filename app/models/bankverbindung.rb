# encoding: UTF-8
class Bankverbindung < ActiveRecord::Base
  self.table_name = "bankverbindung"
  self.primary_key = :id

  # associations
  belongs_to :person, :foreign_key => :pnr, :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
  has_one :ee_konto, :foreign_key => :bankId, :autosave => true, :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
  
  # attributes
  attr_accessible :id, :pnr, :bankKtoNr, :blz, :bic, :iban, :bankName
  
  # validations
  validates :bankKtoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Bankkonto-Nummer an (nur Zahlen 0-9)." }
  validates :blz, :presence => { :message => "Bitte geben Sie eine BLZ an (oder stattdessen IBAN und BIC).", :if => "(iban.nil? or iban.to_s.empty?) and (bic.nil? or bic.to_s.empty?)" }
  validates :blz, :presence => { :format => { :with => /[0-9]+/ }, :if => "!blz.nil? and !blz.to_s.empty?", :message => "Bitte geben Sie eine numerische BLZ an." }
  validates :bankName, :presence => { :message => "Bitte geben Sie den Banknamen an." }
  validates :pnr, :presence => { :message => "Bitte geben Sie die Mitglieder-Nummer der Person an." }
  
  # callbacks
  #after_commit :set_id_for_eekonto
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :id         => 'ID',
    :pnr        => 'Personen-Nr.',
    :bankKtoNr  => 'Kontonummer',
    :blz        => 'BLZ',
    :bic        => 'BIC',
    :iban       => 'IBAN',
    :bankName   => 'Name der Bank'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  #def set_id_for_eekonto
  #  self.EEKonto.first.bankId = 99999
  #end
end
