class CambiarPatenteString < ActiveRecord::Migration[6.0]
  def change
  		remove_column :combis, :patente, :integer
  end
end
