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

ActiveRecord::Schema.define(:version => 20111016113940) do

  create_table "administrators", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bankverbindungs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buchung_onlines", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buchungs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buergschafts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ee_kontos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foerdermitglieds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gesellschafters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kk_verlaufs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kontenklasses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mitglieds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ozb_kontos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ozb_people", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "people" because of following StandardError
#   Unknown type 'enum' for column 'rolle'

  create_table "projektgruppes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tanlistes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tans", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teilnahmes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "telefons", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "veranstaltungs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "veranstaltungsarts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ze_kontos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end