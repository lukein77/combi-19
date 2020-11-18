class CreateUsuariosViajes < ActiveRecord::Migration[6.0]
  def change
    create_table :usuarios_viajes do |t|
      t.belongs_to :usuario
      t.belongs_to :viaje
    end
  end
end
