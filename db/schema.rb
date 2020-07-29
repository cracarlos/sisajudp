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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_30_155651) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tac_actas", id: :integer, default: nil, force: :cascade do |t|
    t.integer "numero_acta", limit: 2, null: false
    t.datetime "creado_el", default: -> { "(now())::timestamp without time zone" }, null: false
    t.string "sede", null: false
    t.integer "tac_firmante_id"
    t.datetime "para"
    t.boolean "estatus", default: true
    t.index ["numero_acta"], name: "tac_actas_numero_acta_key", unique: true
  end

  create_table "tac_cargos", id: :integer, default: nil, force: :cascade do |t|
    t.string "cargos"
  end

  create_table "tac_competencias", id: :integer, default: nil, force: :cascade do |t|
    t.string "competencia", limit: 100
  end

  create_table "tac_extensiones_sedes", id: :integer, default: nil, force: :cascade do |t|
    t.string "coordinaciones_extensiones", limit: 100
    t.integer "tac_unidade_id"
  end

  create_table "tac_firmantes", id: :integer, default: nil, force: :cascade do |t|
    t.string "titulo", limit: 5
    t.string "primer_nombre", limit: 20
    t.string "segundo_nombre", limit: 20
    t.string "primer_apellido", limit: 20
    t.string "segundo_apellido", limit: 20
    t.string "nombre_completo", limit: 60
    t.string "cargo", limit: 50
    t.string "nombramiento", limit: 500
  end

  create_table "tac_juramentado_materias", id: :integer, default: nil, force: :cascade do |t|
    t.integer "tac_juramentado_id"
    t.integer "tac_materia_id"
  end

  create_table "tac_juramentados", id: :integer, default: nil, force: :cascade do |t|
    t.string "primer_nombre", limit: 15, null: false
    t.string "segundo_nombre", limit: 15
    t.string "primer_apellido", limit: 15, null: false
    t.string "segundo_apellido", limit: 15
    t.string "cedula", limit: 9, null: false
    t.string "cargo", null: false
    t.string "resolucion", null: false
    t.integer "tac_competencia_id", null: false
    t.integer "tac_acta_id"
    t.date "fecha_resolucion"
    t.integer "tac_unidade_id", null: false
    t.integer "tac_extensiones_sedes_id"
  end

  create_table "tac_materias", id: :integer, default: nil, force: :cascade do |t|
    t.string "materia", limit: 120, null: false
    t.integer "tac_competencia_id", null: false
  end

  create_table "tac_unidades", id: :integer, default: nil, force: :cascade do |t|
    t.string "coordinaciones_regionales", limit: 100, null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  end

  add_foreign_key "tac_actas", "tac_firmantes", name: "tac_actas_id_firmante_fkey"
  add_foreign_key "tac_extensiones_sedes", "tac_unidades", column: "tac_unidade_id", name: "tac_extensiones_sedes_tac_unidades_id_fkey"
  add_foreign_key "tac_juramentado_materias", "tac_juramentados", name: "tac_juramentado_materias_tac_juramentado_id_fkey"
  add_foreign_key "tac_juramentado_materias", "tac_materias", name: "tac_juramentado_materias_tac_materia_id_fkey"
  add_foreign_key "tac_juramentados", "tac_actas", name: "tac_juramentados_tac_acta_id_fkey"
  add_foreign_key "tac_juramentados", "tac_competencias", name: "\ttac_juramentados_tac_competencias_id_fkey"
  add_foreign_key "tac_materias", "tac_competencias", name: "tac_materias_tac_competencias_id_fkey"
end
