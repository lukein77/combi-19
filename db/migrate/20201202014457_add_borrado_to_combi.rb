class AddBorradoToCombi < ActiveRecord::Migration[6.0]
  def change
	add_column :combis , :borrado , :boolean
  end
end
