class ViajesController < ApplicationController
  def index
    @viajes = Viaje.all
    @rutas = Ruta.all
    @combis = Combi.all
  end

  def new
    @viaje = Viaje.new
    @rutas = Ruta.all
    @combis = Combi.all
  end

  def create
    @rutas = Ruta.all
    @combis = Combi.all
    @viaje = Viaje.new(params.require(:viaje).permit(:ruta_id, :combi_id, :precio, :fecha))
    if @viaje.save
      redirect_to viajes_path, notice: "El viaje fue creado"
    else
      flash[:notice] = "Ha habido un problema al crear el viaje"
      render :new
    end
  end

  def show
    @viaje = Viaje.find(params[:id])
  end

  def update
    @rutas = Ruta.all
    @combis = Combi.all
    if @viaje.update(params.require(:viaje).permit(:ruta_id, :combi_id, :precio, :fecha))
      redirect_to rutas_path, notice: "El viaje fue modificado"
    else
      flash[:notice] = "Ha habido un problema al modificar el viaje"
      render :edit
    end
  end

  def edit
    @viaje = Viaje.find(params[:id])
    @rutas = Ruta.all
    @combis = Combis.all
  end

  def destroy
    Viaje.find(params[:id]).destroy
    redirect_to viajes_path
  end
end
