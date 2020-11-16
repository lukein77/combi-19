class Ciudad < ApplicationRecord
	self.table_name = "ciudades" #ya que no soporta el plural
	#Relaciones
	has_many :rutasDestino, foreign_key: "ciudadDestino", class_name: "Ruta"
	has_many :rutasOrigen, foreign_key: "ciudadOrigen", class_name: "Ruta"

	validates :nombre, uniqueness: { :case_sensitive => false }
end
