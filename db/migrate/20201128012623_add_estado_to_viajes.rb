class AddEstadoToViajes < ActiveRecord::Migration[6.0]
  def change
    add_column :viajes, :estado, :integer, default: 0
  end
end
