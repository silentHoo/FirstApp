# encoding: UTF-8
class BuergschaftController < ApplicationController
  
  # done
  def index
    @buergschaften = Buergschaft.paginate(:page => params[:page], :per_page => 5)
    
    flash[:notice] = "Es sind noch keine Bürgschaften vorhanden." if @buergschaften.size == 0
    
    render "index"
  end

  #done
  def new
    @action = "new"
    
    @buergschaft = Buergschaft.new
    
    render "new"
  end
  
  def edit
    @action = "edit"
    
    @buergschaft = Buergschaft.find(params[:pnrB], params[:mnrG])
    
    render "edit"
  end
  
  def create
    @buergschaft = Buergschaft.new(params[:buergschaft])
    @buergschaft.SachPNR = 1337 # please fix this for production! (I don't know where the current users ID is stored)
    
    if (@buergschaft.save)
      # OK
      flash[:notice] = "Bürgschaft erfolgreich angelegt."
      
      redirect_to :action => "index"
    else
      # Error
      @action = "new"
      
      render "new"
    end
  end
  
  def update
    @buergschaft = Buergschaft.find(params[:pnrB], params[:mnrG])
    
    if (@buergschaft.update_attributes(params[:buergschaft]))
      # OK
      flash[:notice] = "Bürgschaft erfolgreich aktualisiert."
      
      redirect_to :action => "index"
    else
      # Error
      @action = "edit"
      
      render "edit"
    end
  end
  
  def delete
    @buergschaft = Buergschaft.find([params[:pnrB], params[:mnrG]])
    
    if (@buergschaft.destroy)
      # OK
      flash[:notice] = "Bürgschaft erfolgreich gelöscht."
    else
      # Error
      flash[:error] = "Fehler beim Löschen der Bürgschaft."
    end
    
    redirect_to :action => "index"
  end
  
  def ajax_ktonr_collection
    g = Gesellschafter.latest(params[:mnrG])
    
    if (g.ozb_person.nil?)
      render :text => "Keine Person vorhanden"
    elsif (g.ozb_person.ozb_konto.count == 0)
      render :text => "Keine Konten für diese Person vorhanden"
    else
      @ze = Array.new
      g.ozb_person.ozb_konto.each do |o|
        @ze.push(o.ze_konto)
      end
      
      if (@ze.size > 0)
        render :partial => "ajax_ktonr_collection"
      else
        render :text => "Keine ZE-Konten für diese Person vorhanden"
      end
    end
  end

end
