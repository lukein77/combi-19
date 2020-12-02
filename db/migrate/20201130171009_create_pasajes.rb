class CreatePasajes < ActiveRecord::Migration[6.0]
  def change
    create_table :pasajes do |t|
      t.integer :usuario_id
      t.timestamps
    end
  end
end
