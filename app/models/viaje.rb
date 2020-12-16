class Viaje < ApplicationRecord

	#Relaciones
	belongs_to :ruta 
	belongs_to :combi 
	has_and_belongs_to_many :usuarios
	has_many :comentarios, dependent: :destroy
	has_many :pasajes, dependent: :destroy

	before_validation :agregar_hora_llegada
	validate :validar_combi, if: :debe_validar_combi
	validate :validar_chofer, if: :debe_validar_chofer
	validate :validar_dia, if: :fecha_hora_changed?

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

	def validar_dia
		if self.fecha_hora - Time.now > 1.days
			return true
		else
			#errors.add(:fecha_hora, "El horario del viaje debe ser al menos 24hs desde ahora.")
			return false
		end
	end

	def validar_combi
		if combi.validar_fecha_viaje(fecha_hora, fecha_hora_llegada)
			return true
		else
			#errors.add(:combi, "La combi seleccionada fue asignada a otro viaje en esa fecha y horario.")
			#errors.add(:fecha_hora, "La combi seleccionada fue asignada a otro viaje en esa fecha y horario.")
      return false
		end
	end

	def validar_chofer
		@chofer = Usuario.find(chofer_id)
		if @chofer.validar_fecha_viaje(fecha_hora, fecha_hora_llegada)
			return true
		else
			#errors.add(:fecha_hora, "El chofer tiene otro viaje asignado en esa fecha y horario.")
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

	def getEstado
		Viaje.estados.fetch(estado)
	end

	def getDisponibilidad
		Viaje.disponibilidads.fetch(disponibilidad)
	end

	private

	def debe_validar_combi
		combi_id_changed? or fecha_hora_changed?
	end

	def debe_validar_chofer
		chofer_id_changed? or fecha_hora_changed?
	end

	enum estado: { programado: "programado", en_curso: "en curso", finalizado: "finalizado", cancelado: "cancelado" }
	enum disponibilidad: { disponible: "disponible", completo: "completo" }
end
