class FormularioCovid < ApplicationRecord
    belongs_to :usuario

    def actualizado
        updated_at > 48.hours.ago.to_datetime
    end

    def sin_sintomas
        fiebre < 37 and
        !perdida_olfato and
        !perdida_gusto and
        !tos and
        !dolor_garganta and 
        !dificultad_respiratoria and 
        !dolor_cabeza and
        !diarrea and
        !vomitos and
        !dolor_muscular
    end

    def sin_antecedentes
        !convive_con_positivo and
        !estuvo_con_positivo and
        !cancer and
        !diabetes and
        !enfermedad_hepatica and
        !enfermedad_renal and
        !enfermedad_respiratoria and
        !enfermedad_cardiologica and
        !bajas_defensas
    end
end
