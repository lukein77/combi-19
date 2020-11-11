class CreateCombis < ActiveRecord::Migration[6.0]
  def change
    create_table :combis do |t|
      t.integer :patente
      t.integer :asientos
      t.string :modelo
      t.integer :cant_viajes

      t.timestamps
    end
  end
end
