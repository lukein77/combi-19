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
		@viajes_cancelados = []
		@viajes_pendientes = []
		@viajes_realizados = []
		@viajes_no_realizados = []

		if @usuario.rol == "cliente"
			@usuario.pasajes.each do |pasaje|
				@viaje = Viaje.find(pasaje.viaje_id)
				if not @viaje.cancelado?
					if pasaje.default?	
						if @viaje.programado?
							@viajes_pendientes << @viaje
						end
					elsif pasaje.aceptado?
						if @viaje.finalizado?
							@viajes_realizados << @viaje
						elsif @viaje.en_curso?
							@viaje_en_curso = @viaje
						end
					else
						# pasaje rechazado o cancelado
						@viajes_no_realizados << @viaje
					end
				else
					@viajes_cancelados << @viaje
				end 
			end
		elsif @usuario.rol == "chofer"
			@viajes_cancelados = Viaje.where(chofer_id: @usuario.id).cancelado
			@viajes_pendientes = Viaje.where(chofer_id: @usuario.id).programado
			@viajes_realizados = Viaje.where(chofer_id: @usuario.id).finalizado
			@viaje_en_curso = Viaje.find(@usuario.current_viaje)
		end
	end

	def chofer_dar_de_baja
		usuario=Usuario.find(params[:id])
		if  (usuario.viajes.finalizado.count + usuario.viajes.cancelado.count) == usuario.viajes.count
			usuario.borrado = true;
			usuario.save
			redirect_to choferes_index_path
		else
			redirect_to choferes_index_path , notice: "No se pudo eliminar el chofer porque está asignado a un viaje sin finalizar."
		end
	end

	def mostrar_formulario_covid
		@usuario = Usuario.find(params[:id])
		if @usuario.formulario_covid != nil
			redirect_to formulario_covid_path(@usuario.formulario_covid.id)
		else
			redirect_to request.referrer
			flash[:notice] = "El usuario no ha cargado la declaración jurada"
		end
	end

end