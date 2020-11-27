class CreateTarjetas < ActiveRecord::Migration[6.0]
  def change
    create_table :tarjetas do |t|
      t.string :nombre
      t.string :apellido
      t.integer :numero
      t.date :vencimiento

      t.timestamps
    end
  end
end
