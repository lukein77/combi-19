class AddDuracionToRutas < ActiveRecord::Migration[6.0]
  def change
  	add_column :rutas, :duracion, :time
  end
end
