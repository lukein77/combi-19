class CreateFormularioCovids < ActiveRecord::Migration[6.0]
  def change
    create_table :formulario_covids do |t|
      t.float :fiebre
      t.boolean :perdida_olfato
      t.boolean :perdida_gusto
      t.boolean :tos
      t.boolean :dolor_garganta
      t.boolean :dificultad_respiratoria
      t.boolean :dolor_cabeza
      t.boolean :diarrea
      t.boolean :vomitos
      t.boolean :dolor_muscular
      t.boolean :convive_con_positivo
      t.boolean :estuvo_con_positivo
      t.boolean :cancer
      t.boolean :diabetes
      t.boolean :enfermedad_hepatica
      t.boolean :enfermedad_renal
      t.boolean :enfermedad_respiratoria
      t.boolean :enfermedad_cardiologica
      t.boolean :bajas_defensas

      t.timestamps
    end
  end
end
