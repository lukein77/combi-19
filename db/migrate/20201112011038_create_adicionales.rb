class CreateAdicionales < ActiveRecord::Migration[6.0]
  def change
    create_table :adicionales do |t|
      t.string :nombre
      t.string :descripcion
      t.float :precio

      t.timestamps
    end
  end
end
