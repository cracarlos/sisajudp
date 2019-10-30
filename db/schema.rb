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
  enable_extension "postgres_fdw"

  create_table "modeles", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_modeles_on_email", unique: true
    t.index ["reset_password_token"], name: "index_modeles_on_reset_password_token", unique: true
  end

  create_table "tac_actas", id: :serial, force: :cascade do |t|
    t.integer "numero_acta", limit: 2, null: false
    t.datetime "creado_el", default: -> { "(now())::timestamp without time zone" }, null: false
    t.string "sede", null: false
    t.integer "id_firmante"
    t.index ["numero_acta"], name: "tac_actas_numero_acta_key", unique: true
  end

  create_table "tac_cargos", id: :serial, force: :cascade do |t|
    t.string "cargos"
  end

  create_table "tac_competencias", id: :integer, default: -> { "nextval('tac_materias_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "acronimo"
    t.string "nombre_completo"
  end

  create_table "tac_firmantes", id: :serial, force: :cascade do |t|
    t.string "titulo", limit: 5
    t.string "primer_nombre", limit: 20
    t.string "segundo_nombre", limit: 20
    t.string "primer_apellido", limit: 20
    t.string "segundo_apellido", limit: 20
    t.string "nombre_completo", limit: 60
  end

  create_table "tac_juramentados", id: :serial, force: :cascade do |t|
    t.serial "id_tac_actas", null: false
    t.string "primer_nombre", limit: 15, null: false
    t.string "segundo_nombre", limit: 15
    t.string "primer_apellido", limit: 15, null: false
    t.string "segundo_apellido", limit: 15
    t.string "cedula", limit: 9, null: false
    t.string "cargo", null: false
    t.string "sede", null: false
    t.string "resolucion", null: false
    t.string "competencia", null: false
    t.index ["id_tac_actas", "cedula"], name: "tac_juramentados_unico", unique: true
  end

  create_table "tac_pre_juramentados", id: :serial, force: :cascade do |t|
    t.string "primer_nombre", limit: 15, null: false
    t.string "segundo_nombre", limit: 15
    t.string "primer_apellido", limit: 15, null: false
    t.string "segundo_apellido", limit: 15
    t.string "cedula", limit: 9, null: false
    t.string "cargo", null: false
    t.string "sede", null: false
    t.string "resolucion", null: false
    t.string "competencia", null: false
    t.integer "id_numero_acta", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
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

  add_foreign_key "tac_actas", "tac_firmantes", column: "id_firmante", name: "tac_actas_id_firmante_fkey"
  add_foreign_key "tac_juramentados", "tac_actas", column: "id_tac_actas", name: "tac_juramentados_id_tac_actas_fkey"
  add_foreign_key "tac_pre_juramentados", "tac_actas", column: "id_numero_acta", primary_key: "numero_acta", name: "tac_pre_juramentados_id_numero_acta_fkey"
end
