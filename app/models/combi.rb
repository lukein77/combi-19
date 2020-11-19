class Combi < ApplicationRecord
	has_many :viajes, dependent: :destroy
	validates :patente, uniqueness: true
	
	before_save :default_values
	def default_values
		self.cant_viajes = 0 if self.cant_viajes.nil?
	end
end