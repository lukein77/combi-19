class AddFechaHoraLlegadaToViajes < ActiveRecord::Migration[6.0]
  def change
    add_column :viajes, :fecha_hora_llegada, :datetime
  end
end
