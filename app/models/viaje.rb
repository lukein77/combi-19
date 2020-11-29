class Viaje < ApplicationRecord
	#Relaciones
	belongs_to :ruta #foreign_key: "ruta_id", class_name: "Ruta"
	belongs_to :combi #foreign_key: "combi_id", class_name: "Combi"
	has_and_belongs_to_many :usuarios

	validate :validarCombiChofer
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

	def validarCombiChofer
		valido = true
		if not combi.validarFechaViaje(fecha_hora, fecha_hora_llegada)
			errors.add(:combi, "La combi seleccionada fue asignada a otro viaje en esa fecha y horario.")  
        	valido = false
		end
		@chofer = Usuario.find(chofer_id)
		if not @chofer.validarFechaViaje(fecha_hora, fecha_hora_llegada)
			errors.add(:chofer_id, "El chofer tiene otro viaje asignado en esa fecha y horario.")
			valido = false
		end
		return valido 
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
	
	enum estado: { programado: "programado", en_curso: "en curso", finalizado: "finalizado" }
	enum disponibilidad: { disponible: "disponible", completo: "completo" }

end
