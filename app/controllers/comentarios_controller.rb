class ComentariosController < ApplicationController
    def index
    end
    
    def new
        @comentario = Comentario.new
    end

    def create
        @comentario = Comentario.new(params)
        if @comentario.save
            redirect_to viaje_path(@comentario.viaje_id)
        end
    end

    def destroy
        Comentario.find(params[:id]).destroy
    end

    private
    def comentario_params
        params.require(:comentario).permit(:texto, :usuario_id, :viaje_id)
    end
end
