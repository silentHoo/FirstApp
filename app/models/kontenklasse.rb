# encoding: UTF-8
class Kontenklasse < ActiveRecord::Base
  set_table_name "Kontenklasse"
  set_primary_key :kkl
  
  # attributes
  attr_accessible :kkl, :kklAbDatum, :prozent, :kkl_with_percent

  # associations
  has_many :KKLVerlauf, :foreign_key => :kkl # no one or many
  
  # validations
  # ...
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :kkl => 'Kontenklasse-Nr.',
    :kklAbDatum => 'Ab Datum',
    :prozent => 'Prozent'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def validate!
    errors = ActiveModel::Errors.new(self)

    if self.kkl.nil? then
      errors.add("", "Kontenklasse darf nicht leer sein.")
    end
    
    if self.prozent < 0 then
      errors.add("","Bitte geben sie einen Prozentwert größer 0 an.")
    end
    
    if self.kklAbDatum.nil? then
      errors.add("", "Bitte geben sie ein Datum an.")
    end
    
    return errors
  end
  
  # Liefert einen detaillierten String mit dem Prozentsatz
  def kkl_with_percent
	"Klasse " + kkl.to_s + " - " + sprintf("%3.2f", prozent) + "%"
  end
end
