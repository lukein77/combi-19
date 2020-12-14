class RemoveFechaFromViajes < ActiveRecord::Migration[6.0]
  def change
  	remove_column :viajes, :fecha, :date
  end
end
