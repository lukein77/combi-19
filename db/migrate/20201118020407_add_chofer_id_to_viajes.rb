class AddChoferIdToViajes < ActiveRecord::Migration[6.0]
  def change
    add_column :viajes, :chofer_id, :integer
  end
end
