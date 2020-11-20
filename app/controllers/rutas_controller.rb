class RutasController < ApplicationController
  def index
    @rutas = Ruta.all
  end

  def new
    @ruta = Ruta.new
    @ciudades = Ciudad.order(:nombre)
    @adicionales = Adicional.order(:nombre)
  end

  def create
    @ciudades = Ciudad.order(:nombre)
    @adicionales = Adicional.order(:nombre)
    @ruta = Ruta.create(ruta_params)
    if @ruta.save
      redirect_to rutas_path, notice: "La ruta fue creada"
    else
      flash[:error] = "Ha habido un problema al crear la ruta"
      render :new
    end
  end

  def edit
    @ruta = Ruta.find(params[:id])
    @ciudades = Ciudad.order(:nombre)
    @adicionales = Adicional.order(:nombre)
  end

  def show
    @ruta = Ruta.find(params[:id])
  end

  def update
    @ciudades = Ciudad.order(:nombre)
    @adicionales = Adicional.order(:nombre)
    @ruta = Ruta.find(params[:id])
    if @ruta.update(ruta_params)
      redirect_to rutas_path, notice: "La ruta fue modificada."
    else
      flash[:error] = "Ha habido un problema al crear la ruta."
      render :edit
    end
  end

  def destroy
    @ruta = Ruta.find(params[:id])
    if @ruta.viajes.empty? 
      @ruta.destroy
      redirect_to rutas_path
    else
      redirect_to rutas_path, notice: "La ruta tiene viajes asociados."
    end
  end

  private
  def ruta_params 
    params.require(:ruta).permit(:nombre, :ciudadOrigen, :duracion, :ciudadDestino, :adicional_ids => [])
  end
end
