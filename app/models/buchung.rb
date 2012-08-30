class Buchung < ActiveRecord::Base
  self.table_name = "Buchung"
  self.primary_keys = :buchJahr, :ktoNr, :bnKreis, :belegNr, :typ
  
  # attributes
  attr_accessible   :buchJahr, :ktoNr, :bnKreis, :belegNr, :typ, :belegDatum, :buchDatum, 
                    :buchungstext, :sollBetrag, :habenBetrag, :sollKtoNr, :habenKtoNr, 
                    :wSaldoAcc, :punkte, :pSaldoAcc

  # associations
  belongs_to :OZBKonto, :foreign_key => :ktoNr
  
  # validations
  # ...
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :buchJahr       => 'Jahr',
    :ktoNr          => 'Konto-Nr.',
    :bnKreis        => 'Buchungskreis',
    :typ            => 'Typ',
    :belegDatum     => 'Belegdatum',
    :buchDatum      => 'Buchungsdatum',
    :buchungsText   => 'Verwendungszweck',
    :sollBetrag     => 'Betrag (Soll)',
    :habenBetrag    => 'Betrag (Haben)',
    :sollKtoNr      => 'sollKtoNr',
    :habenKtoNr     => 'habenKtoNr',
    :wSaldoAcc      => 'wSaldoAcc',
    :punkte         => 'Punkte',
    :pSaldoAcc      => 'pSaldoAcc'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
