class TarjetasController < ApplicationController
	def new
		@tarjeta = Tarjeta.new
	end

	def create
		@tarjeta = Tarjeta.create(params.require(:tarjeta).permit(:nombre, :apellido, :numero, :vencimiento))
		if @tarjeta.vencimiento.year == Time.now.year and  @tarjeta.vencimiento.mon <= Time.now.month
			flash[:notice] = "El vencimiento no puede ser anterior a la fecha de hoy"
			render :new
		elsif (@tarjeta.numero.to_s.length < 16 or @tarjeta.numero.to_s.length > 19)
			flash[:notice] = "El número de la tarjeta debe entre 16 y 19 dígitos."
			render :new
		else
			@tarjeta.usuario_id = current_usuario.id
    		if @tarjeta.save
      			redirect_to usuario_path(current_usuario), notice: "La tarjeta fue añadida"
    		else
     			flash[:error] = "Ha habido un problema al añadir la tarjeta"
      			render :new
    		end
    	end
	end

	def destroy
		@tarjeta=Tarjeta.find(params[:id]).destroy
		redirect_to usuario_path(current_usuario)
	end
end
