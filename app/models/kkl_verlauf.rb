class KklVerlauf < ActiveRecord::Base
  set_table_name "kklverlauf"
  self.primary_key = :id
  
  # attributes
  attr_accessible :ktoNr, :kklAbDatum, :kkl
  
  # associations
  belongs_to :ozb_konto, :foreign_key => :ktoNr
  belongs_to :kontenklasse, :foreign_key => :kkl
  
  # validations
  validates :ktoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Kontonummer an." }
  validates :kkl, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Kontenklasse an." }
  
  before_create :set_ab_datum
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :id         => 'ID',
    :ktoNr      => 'Konto-Nr.',
    :kklAbDatum => 'Ab Datum',
    :kkl        => 'Kontenklasse'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def set_ab_datum
    if (self.kklAbDatum.blank?)
      self.kklAbDatum = Date.today
    end
  end
end
