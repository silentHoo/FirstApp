class ApplicationController < ActionController::Base
  protect_from_forgery
  @@i = 13213
   
   # find_by_sql
  def searchKtoNr      
    if params[:ktoNr].nil? or params[:mnr].nil? then
        @konten = OZBKonto.paginate(:page => params[:page], :per_page => 5) 
    else
      if params[:ktoNr].empty? and params[:mnr].empty? and  params[:name].empty? and 
      params[:ktoEinrDatum].empty? then
        @konten = OZBKonto.paginate(:page => params[:page], :per_page => 5) 
      else
        @konten = OZBKonto;
        
        if( !params[:ktoNr].empty? ) then
          @konten = @konten.where("ktoNr like ?", "%" + params[:ktoNr] + "%")
        end
        
        if( !params[:mnr].empty? ) then
          @konten = @konten.where("mnr like ?", "%" +  params[:mnr] + "%")
        end
        
        if( !params[:name].empty? or !params[:vorname].empty? ) then
          if !params[:name].empty? and params[:vorname].empty? then
            @personen = Person.where( "(name like ? )", "%" + params[:name] + "%" )
          else
            if !params[:vorname].empty? and params[:name].empty? then
              @personen = Person.where( "(vorname like ? )", "%" + params[:vorname] + "%" )
            else
              @personen = Person.where( "(name like ? AND vorname like ?)", "%" + params[:name] + "%", "%" + params[:vorname] + "%" )
            end
          end
          
          puts @personen.inspect
          pnrs = Array.new
          @personen.each do |person|
            pnrs.push(person.pnr)
          end
          @konten = @konten.where("mnr IN (?)", pnrs)

        end
        
        if( !params[:ktoEinrDatum].empty? ) then
          @konten = @konten.where(:ktoEinrDatum => Date.parse(params[:ktoEinrDatum]))
        end
        
        @konten = @konten.paginate(:page => params[:page], :per_page => 5)
      end
    end
  end
  
  def searchOZBPerson
    #Suchkriterien: mnr, pnr, rolle, name, ktoNr
    @personen = Person.paginate(:page => params[:page], :per_page => 5)
    if params[:sop_mnr].nil? then
      @personen = Person.paginate(:page => params[:page], :per_page => 5)
    else
      if params[:sop_mnr].empty? and params[:sop_name].empty? and 
        params[:sop_ktoNr].empty? and params[:sop_rolle].empty? then
          @personen = Person.paginate(:page => params[:page], :per_page => 5) 
      else
        @personen = Person;
        
        if( !params[:sop_mnr].empty? ) then
          @personen = @personen.where( "pnr like ?", "%" +  params[:sop_mnr] + "%" )
        end
                
        if( !params[:sop_name].empty? or !params[:sop_vorname].empty? ) then
          if !params[:sop_name].empty? and params[:sop_vorname].empty? then
            @personen = Person.where( "(name like ? )", "%" + params[:sop_name] + "%" )
          else
            if !params[:sop_vorname].empty? and params[:sop_name].empty? then
              @personen = Person.where( "(vorname like ? )", "%" + params[:sop_vorname] + "%" )
            else
              @personen = Person.where( "(name like ? AND vorname like ?)", "%" + params[:sop_name] + "%", "%" + params[:sop_vorname] + "%" )
            end
          end
        end
        
        if( !params[:sop_rolle].empty? ) then
          @personen = @personen.where(:rolle => params[:sop_rolle])
        end
        
        if( !params[:sop_ktoNr].empty? ) then
          @konten = OZBKonto.where( "ktoNr LIKE ?", "%" + params[:sop_ktoNr] + "%" )
          
          pnrs = Array.new
          @konten.each do |konto|
            pnrs.push(konto.mnr)
          end
          
          @personen = @personen.where( " pnr IN (?)", pnrs )
        end
        
        @personen = @personen.paginate(:page => params[:page], :per_page => 5)
      end
    end
  end
  
end
