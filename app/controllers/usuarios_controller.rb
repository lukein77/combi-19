class UsuariosController < ApplicationController

	def index
		@usuarios = Usuario.all
	end

	def edit
		@usuario = Usuario.find(params[:id])
	end

	def update
		@usuario = Usuario.find(params[:id])
	    if @usuario.update params.require(:usuario).permit(:rol)
	      redirect_to usuarios_path, notice: "El rol se actualizo correctamente"
	    else
	      flash[:error] = "Hubo un error al modificar el rol"
	      render :edit
	    end
	end

	def show
		@usuario = Usuario.find(params[:id])
	end

end
