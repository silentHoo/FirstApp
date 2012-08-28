# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120731201037) do

  create_table "administrator", :primary_key => "pnr", :force => true do |t|
    t.string "adminPw",    :limit => 35, :null => false
    t.string "adminEmail"
  end

  create_table "adresse", :primary_key => "Pnr", :force => true do |t|
    t.string   "Strasse"
    t.integer  "Nr"
    t.integer  "PLZ"
    t.string   "Ort"
    t.datetime "GueltigVon"
    t.datetime "GueltigBis"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "banks", :force => true do |t|
    t.integer  "BLZ"
    t.string   "BIC"
    t.string   "BankName"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bankverbindung", :force => true do |t|
    t.integer "pnr",                     :null => false
    t.string  "bankKtoNr", :limit => 10
    t.integer "blz"
    t.string  "bic",       :limit => 10
    t.string  "iban",      :limit => 20
    t.string  "bankName",  :limit => 35
  end

  create_table "buchung", :id => false, :force => true do |t|
    t.integer "buchJahr",                                                                   :null => false
    t.integer "ktoNr",        :limit => 8,                                                  :null => false
    t.string  "bnKreis",      :limit => 2,                                                  :null => false
    t.integer "belegNr",                                                                    :null => false
    t.string  "typ",          :limit => 1,                                                  :null => false
    t.date    "belegDatum",                                                                 :null => false
    t.date    "buchDatum",                                                                  :null => false
    t.string  "buchungstext", :limit => 50,                                                 :null => false
    t.decimal "sollBetrag",                 :precision => 10, :scale => 2
    t.decimal "habenBetrag",                :precision => 10, :scale => 2
    t.integer "sollKtoNr",    :limit => 8,                                 :default => 0,   :null => false
    t.integer "habenKtoNr",   :limit => 8,                                 :default => 0,   :null => false
    t.decimal "wSaldoAcc",                  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer "punkte"
    t.integer "pSaldoAcc",                                                 :default => 0,   :null => false
  end

  create_table "buchungonline", :force => true do |t|
    t.integer "mnr",                                     :null => false
    t.date    "ueberwdatum",                             :null => false
    t.integer "sollktonr",   :limit => 8, :default => 0, :null => false
    t.integer "habenktonr",  :limit => 8, :default => 0, :null => false
    t.integer "punkte",                                  :null => false
    t.integer "tan",         :limit => 8,                :null => false
    t.integer "blocknr",     :limit => 2,                :null => false
  end

  create_table "buergschaft", :id => false, :force => true do |t|
    t.integer "pnrB",                                                       :null => false
    t.integer "mnrG",                                                       :null => false
    t.integer "ktoNr",        :limit => 8,                                  :null => false
    t.date    "sichAbDatum"
    t.date    "sichEndDatum"
    t.decimal "sichBetrag",                  :precision => 10, :scale => 2
    t.string  "sichKurzBez",  :limit => 200
    t.integer "SachPNR"
  end

  create_table "eekonto", :primary_key => "ktoNr", :force => true do |t|
    t.integer  "bankId",      :limit => 3
    t.decimal  "kreditlimit",              :precision => 10, :scale => 2, :default => 0.0
    t.datetime "GueltigVon"
    t.datetime "GueltigBis"
    t.integer  "SachPNR"
  end

  create_table "foerdermitglied", :primary_key => "pnr", :force => true do |t|
    t.string   "region",         :limit => 30
    t.decimal  "foerderbeitrag",               :precision => 5, :scale => 2
    t.datetime "GueltigVon"
    t.datetime "GueltigBis"
    t.integer  "SachPNR"
  end

  create_table "geschaeftsprozesse", :force => true do |t|
    t.string   "Beschreibung"
    t.boolean  "IT"
    t.boolean  "MV"
    t.boolean  "RW"
    t.boolean  "ZW"
    t.boolean  "OeA"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "gesellschafter", :primary_key => "mnr", :force => true do |t|
    t.string   "faSteuerNr",        :limit => 15
    t.string   "faLfdNr",           :limit => 20
    t.string   "wohnsitzFinanzamt", :limit => 50
    t.integer  "notarPnr"
    t.date     "beurkDatum"
    t.datetime "GueltigVon"
    t.datetime "GueltigBis"
  end

  create_table "kklverlauf", :force => true do |t|
    t.integer "ktoNr",      :limit => 8, :null => false
    t.date    "kklAbDatum",              :null => false
    t.string  "kkl",        :limit => 1, :null => false
  end

  create_table "kontenklasse", :primary_key => "kkl", :force => true do |t|
    t.date    "kklAbDatum",                                                :null => false
    t.decimal "prozent",    :precision => 5, :scale => 2, :default => 0.0, :null => false
  end

  create_table "mitglied", :primary_key => "mnr", :force => true do |t|
    t.date "rvDatum"
  end

  create_table "ozbkonto", :primary_key => "ktoNr", :force => true do |t|
    t.integer  "mnr",                                                                         :null => false
    t.date     "ktoEinrDatum"
    t.string   "waehrung",     :limit => 3,                                :default => "STR"
    t.decimal  "wSaldo",                    :precision => 10, :scale => 2
    t.integer  "pSaldo"
    t.date     "saldoDatum"
    t.datetime "GueltigVon"
    t.datetime "GueltigBis"
    t.integer  "SachPNR"
  end

  create_table "ozbperson", :primary_key => "mnr", :force => true do |t|
    t.integer  "ueberPnr"
    t.string   "passwort",               :limit => 35
    t.date     "pwAendDatum"
    t.boolean  "gesperrt",                             :default => false, :null => false
    t.boolean  "canEditA",                             :default => false, :null => false
    t.boolean  "canEditB",                             :default => false, :null => false
    t.boolean  "canEditC",                             :default => false, :null => false
    t.boolean  "canEditD",                             :default => false, :null => false
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",                   :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "SachPNR"
  end

  add_index "ozbperson", ["mnr"], :name => "index_OZBPerson_on_mnr", :unique => true
  add_index "ozbperson", ["reset_password_token"], :name => "index_OZBPerson_on_reset_password_token", :unique => true

  create_table "partner", :primary_key => "mnr", :force => true do |t|
    t.integer  "mnrO",                      :null => false
    t.string   "berechtigung", :limit => 1, :null => false
    t.datetime "GueltigVon"
    t.datetime "GueltigBis"
    t.integer  "SachPNR"
  end

  create_table "person", :primary_key => "pnr", :force => true do |t|
    t.string   "rolle",          :limit => 1
    t.string   "name",           :limit => 20,                  :null => false
    t.string   "vorname",        :limit => 15,  :default => "", :null => false
    t.date     "geburtsdatum"
    t.string   "strasse",        :limit => 50
    t.string   "hausnr",         :limit => 10
    t.integer  "plz",            :limit => 8
    t.string   "ort",            :limit => 50
    t.string   "vermerk",        :limit => 100
    t.string   "email"
    t.date     "antragsdatum"
    t.date     "aufnahmedatum"
    t.date     "austrittsdatum"
    t.datetime "GueltigVon"
    t.datetime "GueltigBis"
    t.integer  "SachPNR"
  end

  create_table "projektgruppe", :primary_key => "pgNr", :force => true do |t|
    t.string "projGruppez"
  end

  create_table "sonderberechtigung", :force => true do |t|
    t.integer  "Mnr"
    t.string   "Email"
    t.string   "Berechtigung", :limit => 3
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "student", :primary_key => "mnr", :force => true do |t|
    t.string  "ausbildBez",    :limit => 30
    t.string  "institutName",  :limit => 30
    t.string  "studienort",    :limit => 30
    t.date    "studienbeginn"
    t.date    "studienende"
    t.string  "abschluss"
    t.integer "SachPNR"
  end

  create_table "tan", :id => false, :force => true do |t|
    t.integer "mnr",                      :null => false
    t.integer "listNr",      :limit => 2, :null => false
    t.integer "tanNr",                    :null => false
    t.integer "tan",         :limit => 8, :null => false
    t.date    "verwendetAm"
    t.string  "status",      :limit => 1
  end

  create_table "tanliste", :id => false, :force => true do |t|
    t.integer "mnr",                 :null => false
    t.integer "listNr", :limit => 2, :null => false
    t.string  "status", :limit => 1
  end

  create_table "teilnahme", :id => false, :force => true do |t|
    t.integer "pnr",                   :null => false
    t.integer "vnr",      :limit => 8, :null => false
    t.string  "teilnArt", :limit => 1
  end

  create_table "telefon", :primary_key => "lfdNr", :force => true do |t|
    t.integer "pnr",                      :null => false
    t.string  "telefonNr",  :limit => 15
    t.string  "telefonTyp", :limit => 6
  end

  create_table "veranstaltung", :primary_key => "vnr", :force => true do |t|
    t.integer "vid",                   :null => false
    t.date    "vaDatum",               :null => false
    t.string  "vaOrt",   :limit => 30
  end

  create_table "veranstaltungsart", :force => true do |t|
    t.string "vaBezeichnung", :limit => 30
  end

  create_table "zekonto", :primary_key => "ktoNr", :force => true do |t|
    t.integer  "eeKtoNr",    :limit => 8,                                                  :null => false
    t.integer  "pgNr",       :limit => 2
    t.string   "zeNr",       :limit => 10
    t.date     "zeAbDatum"
    t.date     "zeEndDatum"
    t.decimal  "zeBetrag",                 :precision => 10, :scale => 2
    t.integer  "laufzeit",                                                                 :null => false
    t.string   "zahlModus",  :limit => 1,                                 :default => "M"
    t.decimal  "tilgRate",                 :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "ansparRate",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "kduRate",                  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "rduRate",                  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "zeStatus",   :limit => 1,                                 :default => "A", :null => false
    t.datetime "GueltigVon"
    t.datetime "GueltigBis"
    t.integer  "SachPNR"
  end

end
