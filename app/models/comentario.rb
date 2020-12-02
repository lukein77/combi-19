class Comentario < ApplicationRecord
    belongs_to :usuario
    belongs_to :viaje
end
