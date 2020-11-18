class AddCombiRefToViajes < ActiveRecord::Migration[6.0]
  def change
    add_reference :viajes, :combi, null: false, foreign_key: true
  end
end
