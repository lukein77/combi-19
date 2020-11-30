class UsuariosController < ApplicationController

	def index
		@usuarios = Usuario.all
	end

	def choferes_index
		@choferes = Usuario.where(rol:"chofer")
	end

	def edit
		@usuario = Usuario.find(params[:id])
		#if @usuario.rol == "chofer" and (not @usuario.viajes.empty?)
		#	redirect_back(fallback_location: root_path, notice: "El chofer tiene viajes asignados.")
		#end 
	end

	def update	
		@usuario = Usuario.find(params[:id])
	    if @usuario.update params.require(:usuario).permit(:rol)
		  redirect_to usuarios_path, notice: "El rol se actualizó correctamente"
	    else
	      flash[:error] = "Hubo un error al modificar el rol"
	      render :edit
	    end
	end

	def show
		@usuario = Usuario.find(params[:id])
	end

	def dar_de_baja
		usuario=Usuario.find(params[:id])
		if usuario.viajes.empty?
			usuario.borrado = true;
			usuario.save
			redirect_to choferes_index_path
		else
			redirect_to choferes_index_path , notice: "No se pudo eliminar el chofer porque está asignado a un viaje."
		end
	end

end
