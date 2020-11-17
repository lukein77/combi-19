class Ruta < ApplicationRecord
	self.table_name = "rutas"

	#Relaciones
	belongs_to :ciudad, foreign_key: "ciudadOrigen", class_name: "Ciudad"
	belongs_to :ciudad, foreign_key: "ciudadDestino", class_name: "Ciudad"

	before_validation :poner_nombre
	validates :nombre, presence: true, uniqueness: true
	validate :ciudades_validas
	
	def poner_nombre
		if ciudadOrigen != nil and ciudadDestino != nil
			self.nombre = getCiudadOrigen + " - " + getCiudadDestino
		end
	end

	def ciudades_validas
		if ciudadOrigen == ciudadDestino
			errors.add(:nombre, "No puede elegir la misma ciudad de origen y de destino.")
		end
	end

	#Getters
	def getCiudadOrigen
		Ciudad.find(ciudadOrigen).nombre
	end

	def getCiudadDestino
		Ciudad.find(ciudadDestino).nombre
	end

end
