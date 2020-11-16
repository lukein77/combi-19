class Ruta < ApplicationRecord
	self.table_name = "rutas"

	#Relaciones
	belongs_to :ciudad, foreign_key: "ciudadOrigen", class_name: "Ciudad"
	belongs_to :ciudad, foreign_key: "ciudadDestino", class_name: "Ciudad"
	
	def getCiudadOrigen
		Ciudad.find(ciudadOrigen).nombre
	end
	def getCiudadDestino
		Ciudad.find(ciudadDestino).nombre
	end
end
