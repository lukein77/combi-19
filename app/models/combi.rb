class Combi < ApplicationRecord
	has_many :viajes, dependent: :destroy
	validates :patente, uniqueness: true

	before_save :default_values , unless: :persisted?
	def default_values
	    if self.borrado == nil
      		self.borrado = false
    	end
		self.cant_viajes = 0 if self.cant_viajes.nil?
	end

	def validar_fecha_viaje(salida, llegada)
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