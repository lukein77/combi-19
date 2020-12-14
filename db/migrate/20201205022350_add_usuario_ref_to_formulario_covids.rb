class AddUsuarioRefToFormularioCovids < ActiveRecord::Migration[6.0]
  def change
    add_reference :formulario_covids, :usuario, null: false, foreign_key: true
  end
end
