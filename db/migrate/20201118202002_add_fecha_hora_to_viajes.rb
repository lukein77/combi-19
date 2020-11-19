class AddFechaHoraToViajes < ActiveRecord::Migration[6.0]
  def change
  	add_column :viajes, :fecha_hora, :datetime
  end
end
