class ComentariosController < ApplicationController
    def index
    end
    
    def new
        @comentario = Comentario.new
    end

    def create
        @comentario = Comentario.new(params.require(:comentario).permit(:texto))
        @comentario.usuario_id = current_usuario.id
        # request.referrer devuelve la url donde estaba, en este caso el show de viaje, osea /viajes/id
        # al hacer split, el ultimo elemento es la id del viaje
        @comentario.viaje_id = (request.referrer.split('/').last).to_i
        if @comentario.save
            redirect_to viaje_path(@comentario.viaje_id), notice: "Su comentario se agregó exitosamente."
        else
            redirect_to viaje_path(@comentario.viaje_id), notice: "Hubo un error al procesar su comentario."
        end
    end

    def destroy
        @comentario = Comentario.find(params[:id])
        @id = @comentario.viaje_id
        @comentario.destroy
        redirect_to viaje_path(@id)
    end

    private
    def comentario_params
        params.require(:comentario).permit(:texto)
    end
end
