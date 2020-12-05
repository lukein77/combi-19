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

ActiveRecord::Schema.define(version: 2020_12_05_022350) do

  create_table "adicionales", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.float "precio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "adicionales_and_rutas", force: :cascade do |t|
    t.integer "adicional_id"
    t.integer "ruta_id"
    t.index ["adicional_id"], name: "index_adicionales_and_rutas_on_adicional_id"
    t.index ["ruta_id"], name: "index_adicionales_and_rutas_on_ruta_id"
  end

  create_table "adicionales_pasajes", force: :cascade do |t|
    t.integer "adicional_id"
    t.integer "pasaje_id"
    t.index ["adicional_id"], name: "index_adicionales_pasajes_on_adicional_id"
    t.index ["pasaje_id"], name: "index_adicionales_pasajes_on_pasaje_id"
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
    t.boolean "borrado"
  end

  create_table "comentarios", force: :cascade do |t|
    t.string "texto"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "usuario_id", null: false
    t.integer "viaje_id", null: false
    t.index ["usuario_id"], name: "index_comentarios_on_usuario_id"
    t.index ["viaje_id"], name: "index_comentarios_on_viaje_id"
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
    t.integer "usuario_id", null: false
    t.index ["usuario_id"], name: "index_formulario_covids_on_usuario_id"
  end

  create_table "pasajes", force: :cascade do |t|
    t.integer "usuario_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "viaje_id"
  end

  create_table "rutas", force: :cascade do |t|
    t.string "ciudadOrigen"
    t.string "ciudadDestino"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nombre"
    t.time "duracion"
  end

  create_table "tarjetas", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido"
    t.integer "numero"
    t.date "vencimiento"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "usuario_id"
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
    t.boolean "borrado"
    t.integer "tarjeta_id"
    t.integer "pasaje_id"
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
    t.index ["tarjeta_id"], name: "index_usuarios_on_tarjeta_id"
  end

  create_table "usuarios_viajes", force: :cascade do |t|
    t.integer "usuario_id"
    t.integer "viaje_id"
    t.index ["usuario_id"], name: "index_usuarios_viajes_on_usuario_id"
    t.index ["viaje_id"], name: "index_usuarios_viajes_on_viaje_id"
  end

  create_table "viajes", force: :cascade do |t|
    t.float "precio"
    t.date "fecha"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "combi_id", null: false
    t.integer "ruta_id", null: false
    t.integer "chofer_id"
    t.datetime "fecha_hora"
    t.datetime "fecha_hora_llegada"
    t.string "estado", default: "programado"
    t.string "disponibilidad", default: "disponible"
    t.index ["combi_id"], name: "index_viajes_on_combi_id"
    t.index ["ruta_id"], name: "index_viajes_on_ruta_id"
  end

  add_foreign_key "comentarios", "usuarios"
  add_foreign_key "comentarios", "viajes"
  add_foreign_key "formulario_covids", "usuarios"
  add_foreign_key "viajes", "combis"
  add_foreign_key "viajes", "rutas"
end
