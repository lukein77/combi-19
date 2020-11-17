class Viaje < ApplicationRecord
	#Relaciones
	belongs_to :ruta
	belongs_to :combi
	#belongs_to :chofer
	#has_many :pasajeros
end
