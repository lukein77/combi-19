class AddViajeIdToPasajes < ActiveRecord::Migration[6.0]
  def change
  	add_column :pasajes , :viaje_id , :integer
  end
end
