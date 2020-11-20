class CiudadesController < ApplicationController
  def index
  	@ciudades = Ciudad.order(:nombre)
  end

  def show
    @ciudad = Ciudad.find(params[:id])
  end

  def new
  	@ciudad = Ciudad.new
  end

  def create
  	@ciudad = Ciudad.create(params.require(:ciudad).permit(:nombre))
  	if @ciudad.save
  		redirect_to ciudades_path, notice: "La ciudad fue creada"
  	else
  		flash[:error] = "Ha habido un problema al crear la ciudad"
  		render :new
  	end
  end

  def destroy
    @ciudad = Ciudad.find(params[:id])
    if @ciudad.rutasOrigen.empty? and @ciudad.rutasDestino.empty?
      @ciudad.destroy
      redirect_to ciudades_path
    else
      redirect_to ciudades_path, notice: "La ciudad tiene rutas asociadas."
    end
  end
end
