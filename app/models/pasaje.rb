class Pasaje < ApplicationRecord
	has_one :usuario
	has_and_belongs_to_many :adicionales
	belongs_to :viaje
end
