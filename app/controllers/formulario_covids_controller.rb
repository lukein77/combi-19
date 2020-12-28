class FormularioCovidsController < ApplicationController
    def new
        @formulario_covid = FormularioCovid.new
    end
    
    def create
        @formulario_covid = FormularioCovid.new(formulario_params)
        @formulario_covid.usuario_id = current_usuario.id
        if @formulario_covid.save
            redirect_to root_path, notice: "La declaración jurada fue cargada exitosamente."
        else
            flash[:notice] = "Hubo un error al procesar la solicitud."
            render :new
        end 
    end

    def show
        @formulario_covid = FormularioCovid.find(params[:id])
        @usuario = Usuario.find(@formulario_covid.usuario_id)
        @viaje = Viaje.find(params[:format])
        @pasaje = @viaje.pasajes.find_by(usuario_id: @usuario.id)
    end

    def edit
        @formulario_covid = FormularioCovid.find(params[:id])
    end

    def update
        @formulario_covid = FormularioCovid.find(params[:id])
        @formulario_covid.touch # esto es por si no cambio ningun campo del form y lo guardo
        if @formulario_covid.update(formulario_params)
            redirect_to root_path, notice: "La declaración jurada fue cargada exitosamente."
        else 
            flash[:notice] = "Hubo un error al procesar la solicitud."
            render :edit
        end
    end

    private
    def formulario_params
        # perdon por esto Dios
        params.require(:formulario_covid).permit(:fiebre,
                                                :perdida_olfato,
                                                :perdida_gusto,
                                                :tos,
                                                :dolor_garganta,
                                                :dificultad_respiratoria,
                                                :dolor_cabeza,
                                                :diarrea,
                                                :vomitos,
                                                :dolor_muscular,
                                                :convive_con_positivo,
                                                :estuvo_con_positivo,
                                                :cancer,
                                                :diabetes,
                                                :enfermedad_hepatica,
                                                :enfermedad_renal,
                                                :enfermedad_respiratoria,
                                                :enfermedad_cardiologica,
                                                :bajas_defensas)
    end
end

