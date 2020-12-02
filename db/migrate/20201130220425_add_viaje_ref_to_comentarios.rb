class AddViajeRefToComentarios < ActiveRecord::Migration[6.0]
  def change
    add_reference :comentarios, :viaje, null: false, foreign_key: true
  end
end
