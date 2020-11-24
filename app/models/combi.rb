class Combi < ApplicationRecord
	has_many :viajes, dependent: :destroy
	validates :patente, uniqueness: true
	
	before_save :default_values
	def default_values
		self.cant_viajes = 0 if self.cant_viajes.nil?
	end

	def validarFechaViaje(salida, llegada)
		@viajes = self.viajes
		if not @viajes.empty?
			@viajes.each do |viaje|
				if ((viaje.fecha_hora - 3.hours)..(viaje.fecha_hora_llegada + 3.hours)).overlaps?(salida..llegada)
					return false
				end
			end 
		end
		return true
	end
end