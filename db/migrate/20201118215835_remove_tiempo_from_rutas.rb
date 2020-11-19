class RemoveTiempoFromRutas < ActiveRecord::Migration[6.0]
  def change
  	remove_column :rutas, :tiempo, :float
  end
end
