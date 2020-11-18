class CreateAdicionalesRutas < ActiveRecord::Migration[6.0]
  def change
    create_table :adicionales_rutas do |t|
      t.belongs_to :adicional 
      t.belongs_to :ruta 
    end
  end
end
