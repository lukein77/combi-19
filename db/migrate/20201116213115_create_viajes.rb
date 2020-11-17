class CreateViajes < ActiveRecord::Migration[6.0]
  def change
    create_table :viajes do |t|
      t.float :precio
      t.date :fecha

      t.timestamps
    end
  end
end
