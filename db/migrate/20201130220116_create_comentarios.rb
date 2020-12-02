class CreateComentarios < ActiveRecord::Migration[6.0]
  def change
    create_table :comentarios do |t|
      t.string :texto

      t.timestamps
    end
  end
end
