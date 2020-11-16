class AddFormularioCovidToUsuarios < ActiveRecord::Migration[6.0]
  def change
    add_column :usuarios, :formulario_covid, :formulario_covid
  end
end
