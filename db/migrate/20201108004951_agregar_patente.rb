class AgregarPatente < ActiveRecord::Migration[6.0]
  def change
  		add_column :combis , :patente , :string
  end
end
