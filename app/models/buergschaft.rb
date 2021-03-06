# encoding: UTF-8
class Buergschaft < ActiveRecord::Base 
  set_table_name "Buergschaft"   
   
  attr_accessible  :pnrB, :mnrG, :ktoNr, :sichAbDatum, :sichEndDatum, :sichBetrag, :sichKurzBez
  set_primary_keys :pnrB, :mnrG
   
  belongs_to :person
  belongs_to :OZBPerson
  belongs_to :ZEKonto
  
  def validate(bName, gName)!    
    errors = ActiveModel::Errors.new(self)
    person = nil
    
    # Bürgschafter
    if self.pnrB.nil? then
      names = bName.split(",")
      self.pnrB = find_by_name(names[0], names[-1])
      person = Person.where("pnr = ?", self.pnrB).first
      
      if self.pnrB == 0 then
        self.pnrB = nil
        errors.add("", "Personalnummer oder Name des Bürgschafters konnte nicht gefunden werden.")
      end
    else
      person = Person.where("pnr = ?", self.pnrB).first
    end
   
    if person.nil? then 
      errors.add("", "Personalnummer konnte in der Datenbank nicht gefunden werden.")
    end
    
    # Gesellschafter
    person = nil
    if self.mnrG.nil? then
    
      names = gName.split(",")
      self.mnrG = find_by_name(names[0], names[-1])
      person = Person.where("pnr = ?", self.mnrG).first
      
      if self.mnrG == 0 then
        self.mnrG = nil
        errors.add("", "Mitgliedsnummer oder Name des Gesellschafters konnte nicht gefunden werden.")
      end
      
    else
      person = Person.where("pnr = ?", self.mnrG).first
    end
    
    if person.nil? then 
      errors.add("", "Personalnummer konnte in der Datenbank nicht gefunden werden.")
    else
      if person.rolle != "G" then 
        errors.add("", "Es sind nur Gesellschafter erlaubt.")
      end
    end
    
    # Kontonummer
    if self.ktoNr.nil? then
      errors.add("", "Die Kontonummer darf nicht leer sein.")
    end
    
    # Sicherheitsbetrag
    if self.sichBetrag.nil? then 
      errors.add("", "Bitte geben Sie einen Sicherheitsbetrag größer 0 an.")
    end
    
    if !self.sichBetrag.nil? && self.sichBetrag < 0 then 
      errors.add("", "Bitte geben Sie einen Sicherheitsbetrag größer 0 an.")
    end
    
    # sichAbDatum
    if !self.sichAbDatum.nil? then
      if self.sichAbDatum.to_s.match(/[0-9]{4}-[0-9][0-9]-[0-9][0-9]/).nil? then
        errors.add("", "Bitte geben sie das sichAbDatum im Format: yyyy-mm-dd an.")
      end
    end
    
    # sichEndDatum
    if !self.sichEndDatum.nil? then
      puts self.sichEndDatum.to_s
      if self.sichEndDatum.to_s.match(/[0-9]{4}-[0-9][0-9]-[0-9][0-9]/).nil? then
        errors.add("", "Bitte geben sie das sichEndDatum im Format: yyyy-mm-dd an.")
      end
    end
    
    return errors
  end
  
  def find_by_name(lastname, firstname)
    person = Person.where("name = ? AND vorname = ?", lastname.to_s.strip, firstname.to_s.strip).first
    
    puts person.inspect
    
    if person.nil? then
      return 0
    else
      return person.pnr
    end
    
  end
  
end
