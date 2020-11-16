class Combi < ApplicationRecord
	has_many :viajes
	validates :patente, uniqueness: true
end