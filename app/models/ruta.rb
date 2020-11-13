class Ruta < ApplicationRecord
	self.table_name = "rutas" #ya que no soporta el plural
	#Relaciones
	belongs_to :ciudad #ciudadOrigen
end
