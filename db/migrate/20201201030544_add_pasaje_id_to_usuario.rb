class AddPasajeIdToUsuario < ActiveRecord::Migration[6.0]
  def change
	add_column :usuarios, :pasaje_id, :integer
  end
end
