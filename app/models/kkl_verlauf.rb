class KKLVerlauf < ActiveRecord::Base

  set_table_name "KKLVerlauf"

  attr_accessible :ktoNr, :kklAbDatum, :kkl

  belongs_to :OZBKonto    # Done, ungetestet
  belongs_to :Kontenklasse # Done, ungetestet

  def validate!
    errors = ActiveModel::Errors.new(self)
    
    # Kontonummer
    if self.ktoNr.nil? then
      errors.add("", "Bitte geben sie eine Kontonummer an.")
    else
      if !self.ktoNr.to_s.match(/[0-9]+/) then
        errors.add("", "Die Kontonummer muss eine Zahl sein.")
      end
    end
    
    # Kontenklassenablauf Datum
    if self.kklAbDatum.nil? then
      errors.add("", "Bitte geben sie ein Kontenklassenablauf-Datum an.")
    else
      if !self.kklAbDatum.to_s.match(/[0-9]{4}-[0-9][0-9]-[0-9][0-9]/) then
        errors.add("", "Bitte geben sie das Kontenklassenablauf-Datum im Format: yyyy-mm-dd an.")
      end
    end
    
    # Kontenklasse
    if self.kkl.nil? then
      errors.add("", "Bitte geben sie eine Kontenklasse an.")
    else
      if !self.ktoNr.to_s.match(/[0-9]+/) then
        errors.add("", "Die Kontenklasse muss eine Zahl sein.")
      end
    end
    
    
    return errors
  end

end
