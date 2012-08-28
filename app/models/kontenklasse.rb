# encoding: UTF-8
class Kontenklasse < ActiveRecord::Base
  set_table_name "Kontenklasse"
  set_primary_key :kkl
  
  # attributes
  attr_accessible :kkl, :kklAbDatum, :prozent, :kkl_with_percent

  # associations
  has_many :KKLVerlauf, :foreign_key => :kkl # no one or many
  
  # validations
  validates :kkl, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Klasse an." }
  validates :kklAbDatum, :presence => { :format => { :with => /\d{4}-\d{2}-\d{2}/ }, :message => "Bitte geben Sie eine gültiges Kontenklassenverlaufdatum an." }
  validates :prozent, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie einen gültigen Prozentsatz an." }
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :kkl => 'Kontenklasse-Nr.',
    :kklAbDatum => 'Ab Datum',
    :prozent => 'Prozent'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Liefert einen detaillierten String mit dem Prozentsatz
  def kkl_with_percent
	"Klasse " + kkl.to_s + " - " + sprintf("%3.2f", prozent) + "%"
  end
end
