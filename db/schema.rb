# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.


ActiveRecord::Schema.define(version: 2020_11_15_220138) do

  create_table "adicionales", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.float "precio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
  
  create_table "ciudades", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "combis", force: :cascade do |t|
    t.integer "asientos"
    t.string "modelo"
    t.integer "cant_viajes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "patente"
  end

  create_table "formulario_covids", force: :cascade do |t|
    t.float "fiebre"
    t.boolean "perdida_olfato"
    t.boolean "perdida_gusto"
    t.boolean "tos"
    t.boolean "dolor_garganta"
    t.boolean "dificultad_respiratoria"
    t.boolean "dolor_cabeza"
    t.boolean "diarrea"
    t.boolean "vomitos"
    t.boolean "dolor_muscular"
    t.boolean "convive_con_positivo"
    t.boolean "estuvo_con_positivo"
    t.boolean "cancer"
    t.boolean "diabetes"
    t.boolean "enfermedad_hepatica"
    t.boolean "enfermedad_renal"
    t.boolean "enfermedad_respiratoria"
    t.boolean "enfermedad_cardiologica"
    t.boolean "bajas_defensas"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rutas", force: :cascade do |t|
    t.string "ciudadOrigen"
    t.string "ciudadDestino"
    t.float "tiempo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
  
  create_table "usuarios", force: :cascade do |t|
    t.string "nombre", null: false
    t.string "apellido", null: false
    t.integer "dni", null: false
    t.string "rol"
    t.date "fecha_nacimiento"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
