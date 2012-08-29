# encoding: UTF-8
class OzbKontoController < ApplicationController
  # done
  def index
    @ee_konten = OzbKonto.get_all_ee_for(params[:mnr])
    @ze_konten = OzbKonto.get_all_ze_for(params[:mnr])
    
    render "index"
  end
  
  # done
  def new
    @action = "new"
    
    # view variables: OZBPerson, Person -> DRY!
    @ozb_person = OzbPerson.find(params[:mnr])
    @person = @ozb_person.person
    
    # create new OZBKonto to get fields
    @ozb_konto = OzbKonto.new
    
    if params[:kontotyp] == "EE"
      render "new_ee"
    elsif params[:kontotyp] == "ZE"
      render "new_ze"
    end
  end

  # done
  def create
    @ozb_konto = OzbKonto.new(params[:ozb_konto])
    @ozb_konto.SachPNR = 1337 # please fix this for production! (I don't know where the current users ID is stored)
    
    if (@ozb_konto.save)
      # OK
      flash[:notice] = "OZBKonto erfolgreich angelegt."
      
      redirect_to :action => "index"
    else
      # Error
      @action = "new"
      
      # view variables: OZBPerson, Person -> DRY!
      @ozb_person = OzbPerson.find(params[:mnr])
      @person = @ozb_person.person
      
      if params[:kontotyp] == "EE"
        render "new_ee"
      elsif params[:kontotyp] == "ZE"
        render "new_ze"
      end
    end
  end
  
  # done
  def edit
    @action = "edit"
    
    # view variables: OZBPerson, Person -> DRY!
    @ozb_person = OzbPerson.find(params[:mnr])
    @person = @ozb_person.person
    
    @ozb_konto = OzbKonto.latest(params[:ktoNr])
    
    if params[:kontotyp] == "EE"
      render "edit_ee"
    elsif params[:kontotyp] == "ZE"
      render "edit_ze"
    end
  end
  
  # done
  def update
    OzbKonto.transaction do
      # in Model -> Abhängigkeiten selbst regeln!
      # change old record and add a new one
      @ozb_latest = OzbKonto.find(params[:ktoNr], "9999-12-31 23:59:59")
      @ozb_latest.GueltigBis = Time.now
      
      # Bankverbindung (no valid time! -> just update)
      bv = @ozb_latest.ee_konto.bankverbindung
      bv.bankKtoNr = params[:ozb_konto][:ee_konto_attributes][:bankverbindung_attributes][:bankKtoNr]
      bv.blz = params[:ozb_konto][:ee_konto_attributes][:bankverbindung_attributes][:blz]
      bv.bic = params[:ozb_konto][:ee_konto_attributes][:bankverbindung_attributes][:bic]
      bv.iban = params[:ozb_konto][:ee_konto_attributes][:bankverbindung_attributes][:iban]
      bv.bankName = params[:ozb_konto][:ee_konto_attributes][:bankverbindung_attributes][:bankName]
      
      # EE-Konto (valid time! -> copy and update time stamps of old entry)
      @ozb_latest.ee_konto.GueltigBis = Time.now
      @ozb_latest.save
      
      ee_new = EeKonto.new
      ee_new.ktoNr = params[:ozb_konto][:ktoNr]
      ee_new.bankId = @ozb_latest.ee_konto.bankId 
      ee_new.kreditlimit = params[:ozb_konto][:ee_konto_attributes][:kreditlimit]
      ee_new.GueltigVon = Time.now
      ee_new.GueltigBis = Time.zone.parse("9999-12-31 23:59:59")
      ee_new.SachPNR = 2337 # please fix this for production! (I don't know where the current users ID is stored)
      ee_new.save # copy! -> extra save
      
      # KKL-Verlauf (valid time! -> copy)
      kkl = @ozb_latest.kkl_verlauf
      kkl_new = KklVerlauf.new
      kkl_new.ktoNr = params[:ozb_konto][:ktoNr]
      kkl_new.kklAbDatum = Date.today
      kkl_new.kkl = params[:ozb_konto][:kkl_verlauf_attributes][:kkl]
      kkl_new.save # copy! -> extra save
      
      # this is just a workaround for the bad support of composite_primary_keys
      @ozb_konto = OzbKonto.new(
        :ktoNr => params[:ozb_konto][:ktoNr],
        :mnr => params[:ozb_konto][:mnr],
        :waehrung => "EUR",
        :wSaldo => params[:ozb_konto][:wSaldo],
        :pSaldo => params[:ozb_konto][:pSaldo],
        :saldoDatum => params[:ozb_konto][:saldoDatum]
      )
      
      @ozb_konto.SachPNR = 2337 # please fix this for production! (I don't know where the current users ID is stored)
      
      if (@ozb_konto.save)
        # OK
        flash[:notice] = "OZBKonto erfolgreich aktualisiert."
        
        redirect_to :action => "index"
      else
        # Error
        @action = "edit"
        
        # view variables: OZBPerson, Person -> DRY!
        @ozb_person = OzbPerson.find(params[:mnr])
        @person = @ozb_person.person
        
        if params[:kontotyp] == "EE"
          render "edit_ee"
        elsif params[:kontotyp] == "ZE"
          render "edit_ze"
        end
      end
    end
  end
  
  def show
    @ozb_konto = OZBKonto.where( :ktoNr => params[:ktoNr] ).first
    if params[:typ] == "EE" then
      @konto = @ozb_konto.ee_konto.first
    end
    
    if params[:typ] == "ZE" then
      @konto = @ozb_konto.ze_konto.first
    end
    
    render "show.html.erb"
  end
  
  def delete
    @ozb_konto = OzbKonto.latest(params[:ktoNr])
    
    if (@ozb_konto.destroy)
      flash[:notice] = "Konto wurde erfolgreich gelöscht."
    else
      flash[:error] = "Fehler beim Löschen des Kontos."
    end
    
    redirect_to :action => "index"
  end

  def searchKtoNr
    if current_OZBPerson.canEditB then
      if( !params[:ktoNr].nil? ) then
        @konten = OZBKonto.all
      end
      super
    else 
      redirect_to "/"
    end
  end

  # Kümmert sich um die Änderung der Kontenklasse
  def kkl
    if current_OZBPerson.canEditB then
      @konten = OZBKonto.paginate(:page => params[:page], :per_page => 5)
    else
      redirect_to "/"
    end
  end
  
  # Ändert die Kontoklasse aller angewählten Konten
  def changeKKL
    if current_OZBPerson.canEditB then
      i = 0
      params[:kkl].each do |kkl|
        @verlauf = KKLVerlauf.create( :ktoNr => params[:ktoNr][i], :kklAbDatum => Time.now, :kkl => kkl )
        i += 1
      end
      redirect_to :action => "kkl"
    else 
      redirect_to "/"
    end
  end
  
  # Zeigt den KKLVerlauf an
  def verlauf
    # view variables: OZBPerson, Person -> DRY!
    @ozb_person = OzbPerson.find(params[:mnr])
    @person = @ozb_person.person
    
    @ozb_konto = OzbKonto.latest(params[:ktoNr])
    
    @verlauf = KklVerlauf.find(:all, :conditions => { :ktoNr => params[:ktoNr] }, :order => "kklAbDatum ASC")
    
    render "verlauf"
  end
end