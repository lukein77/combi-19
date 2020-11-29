class Tarjeta < ApplicationRecord
	self.table_name = "tarjetas"
	belongs_to :usuario
end
