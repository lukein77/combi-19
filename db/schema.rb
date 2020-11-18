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

ActiveRecord::Schema.define(version: 2020_11_18_020407) do

  create_table "adicionales", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.float "precio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "adicionales_rutas", force: :cascade do |t|
    t.integer "adicional_id"
    t.integer "ruta_id"
    t.index ["adicional_id"], name: "index_adicionales_rutas_on_adicional_id"
    t.index ["ruta_id"], name: "index_adicionales_rutas_on_ruta_id"
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
    t.string "nombre"
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
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  end

  create_table "usuarios_viajes", force: :cascade do |t|
    t.integer "usuario_id"
    t.integer "viaje_id"
    t.index ["usuario_id"], name: "index_usuarios_viajes_on_usuario_id"
    t.index ["viaje_id"], name: "index_usuarios_viajes_on_viaje_id"
  end

# Could not dump table "viajes" because of following StandardError
#   Unknown type 'combi' for column 'combi'

  add_foreign_key "viajes", "combis"
  add_foreign_key "viajes", "rutas"
end
