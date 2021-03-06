# encoding: UTF-8
class OZBKonto < ActiveRecord::Base

  set_table_name "OZBKonto"

  set_primary_key :ktoNr

  attr_accessible :ktoNr, :mnr, :ktoEinrDatum, :waehrung, :wSaldo, :pSaldo, :saldoDatum

  belongs_to :OZBPerson
    
  has_many :Buchung, :foreign_key => :ktoNr, :dependent => :destroy # Done, getestet
  has_many :KKLVerlauf, :foreign_key => :ktoNr, :dependent => :destroy # Done, getestet
  has_many :ZEKonto, :foreign_key => :ktoNr, :dependent => :destroy # Done, getestet
  has_many :EEKonto, :foreign_key => :ktoNr, :dependent => :destroy # Done, getestet
  
  def validate!
    errors = ActiveModel::Errors.new(self)
    
    # Kontonummer
    if self.ktoNr.nil? then
      errors.add("", "Bitte geben sie eine Kontonummer an.")
    else
      if self.ktoNr.to_s.match(/[0-9]+/).nil? then
        errors.add("", "Die Kontonummer muss eine Zahl sein.")
      end
    end
    
    # Mitgliedsnummer
    if self.mnr.nil? then
      errors.add("", "Bitte geben sie eine Mitgliedsnummer an.")
    else
      if self.mnr.to_s.match(/[0-9]+/).nil? then
        errors.add("", "Die Mitgliedsnummer muss eine Zahl sein.")
      else
        person = OZBPerson.find(self.mnr)
        if person.nil? then
          errors.add("", "Das angegebene Mitglied konnte nicht gefunden werden.")
        end
      end
    end
    
    # Kontoeinrichtungsdatum
    if self.ktoEinrDatum.nil? then
      errors.add("", "Bitte geben sie ein Kontoeinrichtungs-Datum an.")
    else
      if self.ktoEinrDatum.to_s.match(/[0-9]{4}-[0-9][0-9]-[0-9][0-9]/).nil? then
        errors.add("", "Bitte geben sie das Kto-Einrichtungs-Datum im Format: yyyy-mm-dd an.")
      end
    end
    
    # Saldodatum
    if !self.saldoDatum.nil? then
      if self.saldoDatum.to_s.match(/[0-9]{4}-[0-9][0-9]-[0-9][0-9]/).nil? then
        errors.add("", "Bitte geben sie das Saldo-Datum im Format: yyyy-mm-dd an.")
      end
    end
    
    # wSaldo
    if self.wSaldo.nil? then
      errors.add("", "Bitte geben sie einen gültigen Saldowert (>0) an.")
    else
      if self.wSaldo.to_s.match(/[0-9]+/).nil? then
        errors.add("", "Bitte geben sie einen gültigen Zahlenwert > 0 an.")
      else
        if self.wSaldo < 0 then
          errors.add("", "Bitte geben Sie einen positiven Zahlenwert für den Saldo an.")
        end
      end
    end
    
    # Punkte Saldo
    if self.pSaldo.nil? then
      errors.add("", "Bitte geben sie einen gültigen Punkte Saldowert (>0) an.")
    else
      if self.pSaldo.to_s.match(/[0-9]+/).nil? then
        errors.add("", "Bitte geben sie einen gültigen Zahlenwert > 0 an.")
      else
        if self.pSaldo < 0 then
          errors.add("", "Bitte geben Sie einen positiven Zahlenwert für den Punkte-Saldo an.")
        end
      end
    end
    
    return errors
  end
  
end
