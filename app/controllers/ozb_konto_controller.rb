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
    @person = @ozb_person.Person
    
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
      @person = @ozb_person.Person
      
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
    @person = @ozb_person.Person
    
    @ozb_konto = OzbKonto.latest(params[:ktoNr])
    
    if params[:kontotyp] == "EE"
      render "edit_ee"
    elsif params[:kontotyp] == "ZE"
      render "edit_ze"
    end
  end
  
  # done
  def update
    # change old record and add a new one
    #@ozb_konto = OzbKonto.latest(params[:ktoNr])
    ozb_latest = OzbKonto.latest(params[:ktoNr])
    
    ActiveRecord::Base.transaction do
      # in Model -> Abhängigkeiten selbst regeln!
      ozb_latest.GueltigBis = Time.now
      ozb_latest.ee_konto.GueltigBis = Time.now
      
      @ozb_konto = OzbKonto.new(params[:ozb_konto])
      @ozb_konto.SachPNR = 1337 # please fix this for production! (I don't know where the current users ID is stored)
      
      if (@ozb_konto.save)
      #if (@ozb_konto.update_attributes(params[:ozb_konto]))
        # OK
        flash[:notice] = "OZBKonto erfolgreich aktualisiert."
        
        redirect_to :action => "index"
      else
        # Error
        @action = "edit"
        
        # view variables: OZBPerson, Person -> DRY!
        @ozb_person = OzbPerson.find(params[:mnr])
        @person = @ozb_person.Person
        
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
    @person = @ozb_person.Person
    
    @ozb_konto = OzbKonto.latest(params[:ktoNr])
    
    @verlauf = KklVerlauf.find(:all, :conditions => { :ktoNr => params[:ktoNr] }, :order => "kklAbDatum ASC")
    
    render "verlauf"
  end
end