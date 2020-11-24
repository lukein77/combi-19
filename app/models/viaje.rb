class Viaje < ApplicationRecord
	#Relaciones
	belongs_to :ruta #foreign_key: "ruta_id", class_name: "Ruta"
	belongs_to :combi #foreign_key: "combi_id", class_name: "Combi"
	has_and_belongs_to_many :usuarios

	after_save :agregarViajeAChofer

	def agregarViajeAChofer
		@chofer = Usuario.find(chofer_id)
		if @chofer != nil
			@chofer.viajes<<self
		end
	end

	def agregarHoraLlegada
		@duracion = self.ruta.duracion.time
		self.fecha_hora_llegada = self.fecha_hora + @duracion.hour.hours + @duracion.min.minutes
	end

	def getChofer
		Usuario.find(chofer_id).email
	end

	def getRuta
		Ruta.find(ruta_id).nombre
	end

	def getCombi
		Combi.find(combi_id).patente
	end
	
end
