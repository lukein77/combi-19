class CreateAdicionalesPasajes < ActiveRecord::Migration[6.0]
  def change
    create_table :adicionales_pasajes do |t|
	t.belongs_to :adicional
	t.belongs_to :pasaje
    end
  end
end
