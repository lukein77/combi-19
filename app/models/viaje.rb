class Viaje < ApplicationRecord
	
	enum estado: [:programado, :en_curso, :finalizado]

	#Relaciones
	belongs_to :ruta 
	belongs_to :combi 
	has_and_belongs_to_many :usuarios

	validate :validar_combi, if: :combi_id_changed?
	validate :validar_chofer, if: :chofer_id_changed?

	def agregar_viaje_a_chofer
		@chofer = Usuario.find(chofer_id)
		if @chofer != nil
			@chofer.viajes<<self
		end
	end

	def agregar_hora_llegada
		@duracion = self.ruta.duracion.time
		self.fecha_hora_llegada = self.fecha_hora + @duracion.hour.hours + @duracion.min.minutes
	end

	def validar_combi
		if combi.validarFechaViaje(fecha_hora, fecha_hora_llegada)
			return true
		else
			errors.add(:combi, "La combi seleccionada fue asignada a otro viaje en esa fecha y horario.")  
        	return false
		end
	end

	def validar_chofer
		@chofer = Usuario.find(chofer_id)
		if @chofer.validarFechaViaje(fecha_hora, fecha_hora_llegada)
			return true
		else
			errors.add(:chofer_id, "El chofer tiene otro viaje asignado en esa fecha y horario.")
        	return false
		end
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
