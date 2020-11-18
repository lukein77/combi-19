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
    @choferes = Usuario.where(rol: "chofer")
  end

  def create
    @rutas = Ruta.all
    @combis = Combi.all
    @choferes = Usuario.where(rol: "chofer")
    @viaje = Viaje.new(params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio, :fecha))
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
    @choferes = Usuario.where(rol: "chofer")
    @viaje = Viaje.find(params[:id])

    @choferID = @viaje.chofer_id
    puts @choferID.to_s + " ----#----- " + @viaje.chofer_id.to_s
    if @viaje.update(params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio, :fecha))
      if @viaje.chofer_id != @choferID
        # si cambió de chofer
        puts @choferID.to_s + " ---------- " + @viaje.chofer_id.to_s
        Usuario.find(@choferID).viajes.destroy(@viaje)
      end
      redirect_to viajes_path, notice: "El viaje fue modificado"
    else
      flash[:notice] = "Ha habido un problema al modificar el viaje"
      render :edit
    end
  end

  def edit
    @viaje = Viaje.find(params[:id])
    @rutas = Ruta.all
    @combis = Combi.all
    @choferes = Usuario.where(rol: "chofer")
  end

  def destroy
    Viaje.find(params[:id]).destroy
    redirect_to viajes_path
  end
end
