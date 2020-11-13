class Ciudad < ApplicationRecord
	self.table_name = "ciudades" #ya que no soporta el plural
	#Relaciones
	has_many :rutas
end
