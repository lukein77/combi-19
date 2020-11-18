class Viaje < ApplicationRecord
	#Relaciones
	belongs_to :ruta, foreign_key: "ruta_id", class_name: "Ruta"
	belongs_to :combi, foreign_key: "combi_id", class_name: "Combi"
	belongs_to :usuario, foreign_key: "chofer", class_name: "Usuario"
	#has_many :usuarios #pasajeros

	def getChofer
		Usuario.find(chofer).email
	end

	def getRuta
		Ruta.find(ruta_id).nombre
	end

	def getCombi
		Combi.find(combi_id).patente
	end
	
end
