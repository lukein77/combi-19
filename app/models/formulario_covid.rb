class FormularioCovid < ApplicationRecord
    belongs_to :usuario

    def actualizado
        updated_at > 48.hours.ago.to_datetime
    end
end
