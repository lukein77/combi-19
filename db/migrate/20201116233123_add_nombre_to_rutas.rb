class AddNombreToRutas < ActiveRecord::Migration[6.0]
  def change
    add_column :rutas, :nombre, :string
  end
end
