class AddRutaToViajes < ActiveRecord::Migration[6.0]
  def change
  	add_column :viajes, :ruta, :ruta
  end
end