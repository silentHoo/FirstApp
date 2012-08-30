class WebimportController < ApplicationController
  require "CSVImporter"
  
  def index
    render "index"
  end
  
  def csvimport_buchungen
    if !params[:webimport].nil? && !params[:webimport][:file].nil?
      # save CSV-File
      uploaded_io = params[:webimport][:file]
      
      uploaded_disk = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
      File.open(uploaded_disk, 'w') do |file|
        file.write(uploaded_io.read)
      end
      
      # import CSV-File
      csv = CSVImporter.new
      csv.import_from_file(uploaded_disk, ["Belegdatum", "Buchungsdatum", "Belegnummernkreis", "Belegnummer", "Buchungstext", "Buchungsbetrag Euro", "Sollkonto", "Habenkonto"])
      
      # <-> compared to old import.php:
      # $buchungsdatum, $wertstellungsdatum, $belegnummernkreis, $belegnummer, $buchungstext, $betrag, $sollkontonummer, $habenkontonummer
      
      # delete CSV-File
      require 'FileUtils'
      FileUtils.rm(uploaded_disk)
      
      # sort rows by ...
      # rows = csv.rows.sort_by { |r| r[0] }
      rows = csv.rows
      
      @error = csv.error
      @notice = csv.notice
      
      imported_records = 0
      row_counter = 0
      
      collect_konten = Array.new
      rows.each do |r|
        begin
          ActiveRecord::Base.transaction do
            row_counter += 1
            
            habenbetrag = 0.0
            sollbetrag = 0.0
            typ = "w"
            pkte_acc = 0
            storno = 0
            sollkontonummer = r[6].chop.to_i
            habenkontonummer = r[7].chop.to_i
            buchungsdatum = Date.strptime(r[0], "%d.%m.%Y").strftime("%Y-%m-%d")
            buchungsjahr = Date.strptime(r[0], "%d.%m.%Y").strftime("%Y").to_i
            wertstellungsdatum = Date.strptime(r[1], "%d.%m.%Y").strftime("%Y-%m-%d")
            betrag = (r[5].gsub(/\./, '').gsub(/,/, '.')).to_f
            s = r[6].length
            h = r[7].length
            
            if (h == 5 || s == 5)
              if (h == 5 && s == 5)
                # Beide Referenzkonten sind 5-stellig.
                if (habenkontonummer == 88888 && sollkontonummer != 88888)
                  # Eine Abbuchung-Leihpunkte-Buchung. Buchung wird in DB eingetragen.
                  temp = buchungstext.split(" ")
                  temp2 = temp[0].split("-")
                  gesellschafter = temp2[0]
                  darlehensnummer = temp2[1].to_i
                  typ = "p"
                  kontonummer = ZeKonto.find(:all, :conditions => { :zeNr => darlehensnummer, :GueltigBis => "9999-12-31 23:59:59" }).first.eeKtoNr
                  sollbetrag = betrag * (-1.0)
                  
                  b = Buchung.new(
                    :buchJahr => buchungsjahr,
                    :ktoNr => kontonummer,
                    :bnKreis => r[2],
                    :belegNr => r[3].to_i,
                    :typ => typ,
                    :belegDatum => buchungsdatum,
                    :buchDatum => wertstellungsdatum,
                    :buchungstext => r[4],
                    :sollBetrag => sollbetrag,
                    :habenBetrag => habenbetrag,
                    :sollKtoNr => sollkontonummer,
                    :habenKtoNr => habenkontonummer,
                    :wSaldoAcc => 0.0,
                    :punkte => nil,
                    :pSaldoAcc => 0
                  )
                  
                  b.save
                  
                  collect_konten << kontonummer
                  imported_records += 1
                end
                
                if (sollkontonummer == 99999 && habenkontonummer != 88888)
                  # Eine Storno-Abbuchung-Leihpunkte-Buchung. Buchung wird in DB eingetragen.
                  temp = buchungstext.split(" ")
                  temp2 = temp[0].split("-")
                  gesellschafter = temp2[0]
                  darlehensnummer = temp2[1].to_i
                  typ = "p"
                  kontonummer = ZeKonto.find(:all, :conditions => { :zeNr => darlehensnummer, :GueltigBis => "9999-12-31 23:59:59" }).first.eeKtoNr
                  sollbetrag = betrag
                  
                  b = Buchung.new(
                    :buchJahr => buchungsjahr,
                    :ktoNr => kontonummer,
                    :bnKreis => r[2],
                    :belegNr => r[3].to_i,
                    :typ => typ,
                    :belegDatum => buchungsdatum,
                    :buchDatum => wertstellungsdatum,
                    :buchungstext => r[4],
                    :sollBetrag => sollbetrag,
                    :habenBetrag => habenbetrag,
                    :sollKtoNr => sollkontonummer,
                    :habenKtoNr => habenkontonummer,
                    :wSaldoAcc => 0.0,
                    :punkte => nil,
                    :pSaldoAcc => 0
                  )
                  
                  b.save
                  
                  collect_konten << kontonummer
                  imported_records += 1
                end
                
                if (habenkontonummer[0] == "8" && sollkontonummer[0] == "8" && sollkontonummer != 88888 && habenkontonummer != 88888)
                  # Eine Punkteüberweisung-Buchung.Buchung wird in DB eingetragen.
                  
                  # Erste Buchung
                  temp = buchungstext.split(" ")
                  temp2 = temp[0].split("-")
                  kontonummer = temp2[0].to_i
                  kontonummer2 = temp2[1].to_i
                  sollbetrag = betrag * (-1.0)
                  typ = "p"
                  
                  b = Buchung.new(
                    :buchJahr => buchungsjahr,
                    :ktoNr => kontonummer,
                    :bnKreis => r[2],
                    :belegNr => r[3].to_i,
                    :typ => typ,
                    :belegDatum => buchungsdatum,
                    :buchDatum => wertstellungsdatum,
                    :buchungstext => r[4],
                    :sollBetrag => sollbetrag,
                    :habenBetrag => habenbetrag,
                    :sollKtoNr => sollkontonummer,
                    :habenKtoNr => habenkontonummer,
                    :wSaldoAcc => 0.0,
                    :punkte => nil,
                    :pSaldoAcc => 0
                  )
                  
                  b.save
                  
                  collect_konten << kontonummer
                  imported_records += 1
                  
                  # Zweite Buchung
                  
                  kontonummer = kontonummer2
                  sollbetrag = 0.0
                  habenbetrag = betrag
                  
                  b = Buchung.new(
                    :buchJahr => buchungsjahr,
                    :ktoNr => kontonummer,
                    :bnKreis => r[2],
                    :belegNr => r[3].to_i,
                    :typ => typ,
                    :belegDatum => buchungsdatum,
                    :buchDatum => wertstellungsdatum,
                    :buchungstext => r[4],
                    :sollBetrag => sollbetrag,
                    :habenBetrag => habenbetrag,
                    :sollKtoNr => sollkontonummer,
                    :habenKtoNr => habenkontonummer,
                    :wSaldoAcc => 0.0,
                    :punkte => nil,
                    :pSaldoAcc => 0
                  )
                  
                  b.save
                  
                  collect_konten << kontonummer
                  imported_records += 1
                end
                
                if (habenkontonummer[0] != "8" && sollkontonummer[0] != "8")
                  # Eine Konto-zu-Konto-Buchung.Buchung wird in DB eingetragen.
                  
                  # Erste Buchung
                  kontonummer = sollkontonummer
                  sollbetrag = betrag
                  habenbetrag = 0.0
                  typ = "w"
                  
                  b = Buchung.new(
                    :buchJahr => buchungsjahr,
                    :ktoNr => kontonummer,
                    :bnKreis => r[2],
                    :belegNr => r[3].to_i,
                    :typ => typ,
                    :belegDatum => buchungsdatum,
                    :buchDatum => wertstellungsdatum,
                    :buchungstext => r[4],
                    :sollBetrag => sollbetrag,
                    :habenBetrag => habenbetrag,
                    :sollKtoNr => sollkontonummer,
                    :habenKtoNr => habenkontonummer,
                    :wSaldoAcc => 0.0,
                    :punkte => nil,
                    :pSaldoAcc => 0
                  )
                  
                  b.save
                  
                  collect_konten << kontonummer
                  imported_records += 1
                  
                  # Zweite Buchung
                  kontonummer = habenkontonummer
                  sollbetrag = 0.0
                  habenbetrag = betrag
                  typ = "w"
                  
                  b = Buchung.new(
                    :buchJahr => buchungsjahr,
                    :ktoNr => kontonummer,
                    :bnKreis => r[2],
                    :belegNr => r[3].to_i,
                    :typ => typ,
                    :belegDatum => buchungsdatum,
                    :buchDatum => wertstellungsdatum,
                    :buchungstext => r[4],
                    :sollBetrag => sollbetrag,
                    :habenBetrag => habenbetrag,
                    :sollKtoNr => sollkontonummer,
                    :habenKtoNr => habenkontonummer,
                    :wSaldoAcc => 0.0,
                    :punkte => nil,
                    :pSaldoAcc => 0
                  )
                  
                  b.save
                  
                  collect_konten << kontonummer
                  imported_records += 1
                end
              else
                # falls nicht beide Konten 5-stellig sind
                
                if (gesellschafter.index("<Storno>") != nil)
                  # wenn Storno-Buchung lösche die entsprechende Buchung aus DB
                  kontonummer = sollkontonummer.to_i
                  
                  b = Buchung.find(:all, :conditions => { :bnKreis => r[2], :belegNr => r[3], :belegDatum => buchungsdatum, :ktoNr => kontonummer })
                  b.delete
                  
                  collect_konten << kontonummer
                end
                
                # Eine gewöhnliche Buchung. Buchung wird in DB eingetragen.
                if (h == 5)
                  kontonummer = habenkontonummer
                  habenbetrag = betrag
                  
                  b = Buchung.new(
                    :buchJahr => buchungsjahr,
                    :ktoNr => kontonummer,
                    :bnKreis => r[2],
                    :belegNr => r[3].to_i,
                    :typ => typ,
                    :belegDatum => buchungsdatum,
                    :buchDatum => wertstellungsdatum,
                    :buchungstext => r[4],
                    :sollBetrag => sollbetrag,
                    :habenBetrag => habenbetrag,
                    :sollKtoNr => sollkontonummer,
                    :habenKtoNr => habenkontonummer,
                    :wSaldoAcc => 0.0,
                    :punkte => nil,
                    :pSaldoAcc => 0
                  )
                  
                  b.save
                  
                  collect_konten << kontonummer
                  imported_records += 1
                elsif (s == 5)
                  kontonummer = habenkontonummer
                  sollbetrag = betrag
                  
                  b = Buchung.new(
                    :buchJahr => buchungsjahr,
                    :ktoNr => kontonummer,
                    :bnKreis => r[2],
                    :belegNr => r[3].to_i,
                    :typ => typ,
                    :belegDatum => buchungsdatum,
                    :buchDatum => wertstellungsdatum,
                    :buchungstext => r[4],
                    :sollBetrag => sollbetrag,
                    :habenBetrag => habenbetrag,
                    :sollKtoNr => sollkontonummer,
                    :habenKtoNr => habenkontonummer,
                    :wSaldoAcc => 0.0,
                    :punkte => nil,
                    :pSaldoAcc => 0
                  )
                  
                  b.save
                  
                  collect_konten << kontonummer
                  imported_records += 1
                end
              end
            else
              # Eine FIBU-Buchung. Buchung wird ignoriert.
            end
          end
        end
      end
      
      # berechnen der Saldo und Punktesaldo für Konten
      if (collect_konten.size == 0)
        @error = "Keine der zu importierenden Konten in der Datenbank eingetragen"
      else
        collect_konten.uniq!.each do |ktoNr|
          b = Buchung.find(:all, :conditions => { :ktoNr => ktoNr }, :order => "belegDatum ASC, typ DESC, habenBetrag DESC, sollBetrag DESC, pSaldoAcc DESC")
          
          saldo_acc = 0.0 # wSaldoAcc
          pkte_acc = 0 # pSaldoAcc
          first_time = b.belegDatum
          last_saldo_acc = 0.0
          end_pkte_acc = 0
          
          # Berechne Daten für die nächste Buchung
          b.each do |buchung|
            if (buchung.typ == "w")
              second_time = buchung.belegDatum
              saldo_acc = saldo_acc + buchung.habenBetrag - buchung.sollBetrag
              
              if (second_time != first_time)
                pkte_acc = calc_score(first_time, second_time, last_saldo_acc, ktoNr).to_i
                end_pkte_acc = end_pkte_acc + pkte_acc
              end
              
              b = Buchung.find(:all, :conditions => ["ktoNr = ? AND belegNr = ? AND belegDatum = ?", buchung.ktoNr, buchung.belegNr, buchung.belegDatum])
              b.update_attributes(
                :wSaldoAcc => saldo_acc,
                :pSaldoAcc => pkte_acc,
                :punkte => end_pkte_acc
              )
              b.save
              
              first_time = second_time
              last_saldo_acc = saldo_acc
              pkte_acc = 0
              last_saldo_data = buchung.belegDatum
            end
            
            if (buchung.typ == "p")
              end_pkte_acc = end_pkte_acc + buchung.sollbetrag + buchung.habenbetrag
              
              b = Buchung.find(:all, :conditions => ["ktoNr = ? AND belegNr = ? AND belegDatum = ?", buchung.ktoNr, buchung.belegNr, buchung.belegDatum])
              b.update_attributes(
                :wSaldoAcc => saldo_acc,
                :pSaldoAcc => 0.00,
                :punkte => end_pkte_acc
              )
              b.save
            end
          end
          
          # das End-Saldo ins Konto eintragen
          konto = OzbKonto.find(:all, :conditions => { :ktoNr => ktoNr }).first
          konto.update_attributes(
            :wSaldo => saldo_acc,
            :pSaldo => end_pkte_acc,
            :saldoDatum => last_saldo_data
          )
          konto.save
        end
      end
      
      @notice += "<br /><br />" + csv.number_records.to_s + " von " + csv.rows.size.to_s + " Datensätzen eingelesen."
      @notice += "<br />" + imported_records.to_s + " Datensätze importiert."
    else
      @error = "Bitte geben Sie eine CSV-Datei an."
    end
    
    render "index"
  end
  
  def calc_score(date_begin, date_end, money_begin, kontonummer)
    t = Array.new
    t << date_begin.tomorrow
    tt = Array.new
    tt << Time::days_in_month(date_begin.month, date_begin.year)
    b = date_begin.to_time.to_i
    e = date_end.to_time.to_i
    d = b + ((tt[0] - date_begin.day) * 86400) # Differenz der Tage bis zum Ende des Monats in Sekunden
    
    while d <= e do
      t << Time.at(d).strftime("%Y-%m-%d")
      b = d + 86400 # +1 Tag
      t << Time.at(b).strftime("%Y-%m-%d")
      d = b + (Time::days_in_month(Time.at(b).to_datetime) - 1) * 86400
      tt << Time::days_in_month(Time.at(d).to_datetime)
    end
    
    t << date_end
    
    mfaktor = 0
    i = 0
    while i < t.size
      mfaktor += calc_score_1(t[i], t[i+1], money_begin, tt[i/2], kontonummer)
      
      i += 2
    end
    
    return mfaktor
  end
  
  def calc_score_1(date_begin, date_end, money_begin, months_days, kontonummer)
    db_begin = KklVerlauf.find(:all, :conditions => ["ktoNr = ? AND kklAbDatum <= ?", kontonummer, date_begin], :order => "kklAbDatum DESC").first
    db_duration = KklVerlauf.find(:all, :conditions => ["ktoNr = ? AND kklAbDatum <= ? AND kklAbDatum > ?", kontonummer, date_end, date_begin], :order => "kklAbDatum ASC")
    
    t = Array.new
    t << date_begin
    t << db_begin.kkl
    
    db_duration.each do |temp1|
      t << temp1.kklAbDatum
      t << temp1.kkl
    end
    
    t << date_end.tomorrow
    t << "dummy" # wo wird das gebraucht?
    
    mfaktor = 0
    scores = 0
    
    i = 0
    while i < (t.size - 2)
      # 01.2011: beim neg. Saldo keine berücksichtigung der KKL-Prozenzsatzes, stattdessen immer KKL 100% annehmen
      if (money_begin >= 0)
        mfaktor = calc_percentage(t[i], t[i+2], t[i+1]) # Anzahl der Tage um KKL-Prozentsatz verringern
      else
        mfaktor = count_days_exact(t[i], t[i+2]) # Volle Anzahl der Tage als Faktor nehmen
      end
      
      scores += mfaktor * (money_begin / 30)
      
      i += 2
    end
    
    return scores
  end
  
  def calc_percentage(date_begin, date_end, kkl)
    db_begin = Kontenklasse.find(:all, :conditions => ["kkl = ? AND kklAbDatum <= ?", kkl, date_begin], :order => "kklAbDatum DESC", :limit => 1).first
    db_duration = Kontenklasse.find(:all, :conditions => ["kkl = ? AND kklAbDatum <= ? AND kklAbDatum > ?", kkl, date_end, date_begin], :order => "kklAbDatum ASC")
    
    db_duration.each do |temp1|
      t << temp1.kklAbDatum
      t << temp1.prozent
    end
    
    t << date_end
    t << "dummy"
    
    # rechne gemittelte Tage
    mtage = 0
    i = 0
    while i < (t.size - 2)
      mtage += (count_days_exact(t[i], t[i+2])) * (t[i+1] / 100)
      
      i += 2
    end
    
    return mtage
  end
  
  def count_days_exact(first_time, second_time)
    # wurde beobachtet,dass das ergebnis mit nachkommastellen berechnet wird => rundung nötig!
    return ((second_time.to_time.to_i - first_time.to_time.to_i) / 86400.0).round(0) # integer / float => float
  end
end