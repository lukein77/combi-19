class CombisController < ApplicationController

	def index
		@combis = Combi.all
	end

	def show
		@combi = Combi.find(params[:id])
	end

	def new
		@combi = Combi.new
	end

	def create
		@combi = Combi.create(params.require(:combi).permit(:patente, :asientos, :modelo))
		@combi.cant_viajes = 0
	    if @combi.save
	      redirect_to combis_path, notice: "La combi se añadio exitosamente"
	    else
	      flash[:error] = "Hubo un error al añadir la combi"
	      render :new
	    end
	end

	def edit
		@combi = Combi.find(params[:id])
	end

	def update
		@combi = Combi.find(params[:id])
	    if @combi.update params.require(:combi).permit(:patente, :asientos, :modelo)
	      redirect_to combis_path, notice: "La combi se modifico exitosamente"
	    else
	      flash[:error] = "Hubo un error al modificar la combi"
	      render :edit
	    end
	end

	def destroy
		@combi = Combi.find(params[:id])
		if @combi.viajes.empty?
			@combi.destroy
			redirect_to combis_path
		else
			redirect_to combis_path, notice: "La combi tiene viajes asociados."
		end
	end

	def combi_dar_de_baja
		combi = Combi.find(params[:id])
		if combi.viajes.finalizado.count < combi.viajes.count
			combi.borrado = true
			combi.save
			redirect_to combis_path
		else
			redirect_to combis_path, notice: "La combi tiene viajes asociados."
		end
	end
end
