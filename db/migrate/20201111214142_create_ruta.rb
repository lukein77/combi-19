class CreateRuta < ActiveRecord::Migration[6.0]
  def change
    create_table :ruta do |t|
      t.string :ciudadOrigen
      t.string :ciudadDestino
      t.float :tiempo

      t.timestamps
    end
  end
end
