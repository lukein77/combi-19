class AddEstadoToPasajes < ActiveRecord::Migration[6.0]
  def change
    add_column :pasajes, :estado, :string, default: "default"
  end
end
