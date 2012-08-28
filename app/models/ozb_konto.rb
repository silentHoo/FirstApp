# encoding: UTF-8
class OzbKonto < ActiveRecord::Base
  self.table_name = "ozbkonto"
  self.primary_keys = :ktoNr, :GueltigBis # two primary keys define an unique record
  
  # associations
  belongs_to :ozb_person, :foreign_key => :mnr
  has_many :buchung, :foreign_key => :ktoNr, :dependent => :destroy
  
  # this differs from the db model -> there are in 'real' many ZeKonto for this record, but we have a historic database where at a point of time only one record is valid!
  has_one :kkl_verlauf, 
    :foreign_key => :ktoNr,
    :primary_key => :id,
    :dependent => :destroy, 
    :class_name => "KklVerlauf", 
    :order => "kklAbDatum DESC" # order is important to match the latest record!
  
  # this differs from the db model -> there are in 'real' many ZeKonto for this record, but we have a historic database where at a point of time only one record is valid!
  has_one :ze_konto, 
    :foreign_key => :ktoNr,
    :primary_key => :ktoNr, 
    :dependent => :destroy, 
    :class_name => "ZeKonto", 
    :autosave => true, 
    :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
  
  # this differs from the db model -> there are in 'real' many ZeKonto for this record, but we have a historic database where at a point of time only one record is valid!
  has_one :ee_konto,
    :foreign_key => :ktoNr, 
    :primary_key => :ktoNr,
    :dependent => :destroy,
    :class_name => "EeKonto", 
    :autosave => true, 
    :conditions => "GueltigBis = \"9999-12-31 23:59:59\"" # condition -> for historic db
    
  belongs_to :sachbearbeiter,
    :foreign_key => :Pnr, 
    :primary_key => :SachPNR, 
    :class_name => "Person"
  
  # attributes
  # accept only and really only attr_accessible if you want that a user is able to mass-assign these attributes!
  attr_accessible :ktoNr, :mnr, :ktoEinrDatum, :waehrung, :wSaldo, :pSaldo, :saldoDatum, :GueltigBis, :ee_konto_attributes, :ze_konto_attributes, :kkl_verlauf_attributes
  accepts_nested_attributes_for :ee_konto, :ze_konto, :kkl_verlauf
  
  # validations
  # validate always things you will accept nested attributes for!
  validates_associated :ee_konto, :ze_konto
  validates :ktoNr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Kontonummer an." }
  validates :mnr, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie eine gültige Mitgliedsnummer an." }
  validates :saldoDatum, :presence => { :format => { :with => /\d{4}-\d{2}-\d{2}/ }, :message => "Bitte geben Sie ein gültiges Saldodatum ein." }
  validates :pSaldo, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie einen gültigen Punktesaldo an." }
  validates :wSaldo, :presence => { :format => { :with => /[0-9]+/ }, :message => "Bitte geben Sie einen gültigen Währungssaldo an." }
  validates :waehrung, :presence => { :format => { :with => /[A-Z]+/ }, :message => "Bitte geben Sie eine gültige Währung an." }
  # GueltigVon und GueltigBis wird durch Model selbst gesetzt
  # Sachbearbeiter muss durch Controller gesetzt werden!
  
  # callbacks
  before_save :set_assoc_attributes
  before_create :set_valid_time, :set_einr_datum
  before_update :set_new_valid_time
  
  # column names
  HUMANIZED_ATTRIBUTES = {
    :ktoNr          => 'Konto-Nr.',
    :mnr            => 'Mitglieder-Nr.',
    :ktoEinrDatum   => 'Einrichtungsdatum',
    :waehrung       => 'Währung',
    :wSaldo         => 'Währungssaldo',
    :pSaldo         => 'Punktesaldo',
    :saldoDatum     => 'Saldo Datum',
    :GueltigVon     => 'Gültig von',
    :GueltigBis     => 'Gültig bis',
    :ee_konten      => 'EE-Konto (Bankverbindung)'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # bound to callback
  def set_assoc_attributes
    #self.ee_konto.each do |ee|
    #  ee.SachPNR = self.SachPNR
    #end
    self.ee_konto.SachPNR = self.SachPNR
    #self.ee_konto.ktoNr = self.ktoNr # this is necessary? check pls! Shouldn't that be set automatically via has_one association?
  end
  
  # bound to callback
  def set_valid_time
    unless(self.GueltigBis || self.GueltigVon)
      self.GueltigVon = Time.now
      self.GueltigBis = Time.zone.parse("9999-12-31 23:59:59")
    end
  end
  
  # bound to callback
  def set_einr_datum
    if (self.ktoEinrDatum.blank?)
      self.ktoEinrDatum = Time.now
    end
	end
	
	# bound to callback
  def set_new_valid_time
    if(self.ktoNr)
      if(self.GueltigBis > "9999-01-01 00:00:00")
        copy = self.get(self.KtoNr)
        copy = copy.dup
        copy.KtoNr = self.KtoNr
        copy.GueltigVon = self.GueltigVon
        copy.GueltigBis = Time.now
        copy.save!
        
        self.GueltigVon = Time.now
        self.GueltigBis = Time.zone.parse("9999-12-31 23:59:59")
      end
    end
  end
  
  # Static method
  # Returns all EE-Konten for the specified person at ALL TIME
  def self.get_all_ee_for(mnr)
    ozb_konto = self.where(:mnr => mnr)
    @ee_konto = Array.new
    
    ozb_konto.each do |konto|
      #if konto.ee_konto.count > 0 then
      #  @ee_konto.push(konto.ee_konto.first)
      #end
      if !konto.ee_konto.nil?
        @ee_konto.push(konto.ee_konto)
      end
    end
    
    return @ee_konto
  end
  
  # Static method
  # Returns all ZE-Konten for the specified person at ALL TIME
  def self.get_all_ze_for(mnr)
    ozb_konto = self.where(:mnr => mnr)
    @ze_konto = Array.new
    
    ozb_konto.each do |konto|
      #if konto.ze_konto.count > 0 then
      #  @ze_konto.push(konto.ze_konto.first)
      #end
      if !konto.ze_konto.nil?
        @ze_konto.push(konto.ze_konto)
      end
    end
    
    return @ze_konto
  end

  # Returns the OZBKonto Object for ktoNr and date
  def get(ktoNr, date = Time.now)
    #self.where(:KtoNr => ktoNr).where(["GueltigVon <= ?", date]).where(["GueltigBis > ?",date]).first
    self.find(:all, :conditions => ["ktoNr = ? AND GueltigVon <= ? AND GueltigBis > ?", ktoNr, date, date]).first
  end
  
  # Returns the latest/newest OZBKonto Object
  def self.latest(ktoNr)
    self.find(ktoNr, "9999-12-31 23:59:59") # composite primary key gem
  end
end
