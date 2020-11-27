class AddUsuarioIdToTarjeta < ActiveRecord::Migration[6.0]
  def change
  	add_column :tarjetas , :usuario_id , :integer
  end
end
