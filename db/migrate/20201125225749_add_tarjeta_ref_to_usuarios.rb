class AddTarjetaRefToUsuarios < ActiveRecord::Migration[6.0]
  def change
	add_reference :usuarios, :tarjeta
  end
end
