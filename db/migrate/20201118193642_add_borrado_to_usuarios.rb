class AddBorradoToUsuarios < ActiveRecord::Migration[6.0]
  def change
    add_column :usuarios, :borrado, :boolean
  end
end
