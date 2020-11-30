class AddDisponibilidadToViajes < ActiveRecord::Migration[6.0]
  def change
  	add_column :viajes, :disponibilidad, :string, default: "disponible"
  end
end