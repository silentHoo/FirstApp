class KKLVerlauf < ActiveRecord::Base
  set_table_name "KKLVerlauf"
  set_primary_key :id
  
  # attributes
  attr_accessible :ktoNr, :kklAbDatum, :kkl
  
  # associations
  belongs_to :OZBKonto, :foreign_key => :ktoNr
  belongs_to :Kontenklasse, :foreign_key => :kkl
  
  # validations
  # ...
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :id => 'ID',
    :ktoNr => 'Konto-Nr.',
    :kklAbDatum => 'Ab Datum',
    :kkl    => 'Kontenklasse'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def validate!
    errors = ActiveModel::Errors.new(self)
    
    # Kontonummer
    if self.ktoNr.nil? then
      errors.add(:ktoNr, "Bitte geben Sie eine Kontonummer an.")
    else
      if !self.ktoNr.to_s.match(/[0-9]+/) then
        errors.add(:ktoNr, "Die Kontonummer muss eine Zahl sein.")
      end
    end
    
    # Kontenklassenablauf Datum
    if self.kklAbDatum.nil? then
      errors.add(:kklAbDatum, "Bitte geben sie ein Kontenklassenablauf-Datum an.")
    else
      if !self.kklAbDatum.to_s.match(/[0-9]{4}-[0-9][0-9]-[0-9][0-9]/) then
        errors.add(:kklAbDatum, "Bitte geben sie das Kontenklassenablauf-Datum im Format: yyyy-mm-dd an.")
      end
    end
    
    # Kontenklasse
    if self.kkl.nil? then
      errors.add(:kkl, "Bitte geben sie eine Kontenklasse an.")
    else
      if !self.ktoNr.to_s.match(/[0-9]+/) then
        errors.add(:ktoNr, "Die Kontenklasse muss eine Zahl sein.")
      end
    end
    
    
    return errors
  end

end
