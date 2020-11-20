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
    @choferes = Usuario.where(rol: "chofer").where(borrado: false)
  end

  def create
    @rutas = Ruta.all
    @combis = Combi.all
    @choferes = Usuario.where(rol: "chofer").where(borrado: false)
    @viaje = Viaje.new(params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio, :fecha_hora))
    if @viaje.fecha_hora - Time.now > 1.days
      if @viaje.save
        redirect_to viajes_path, notice: "El viaje fue creado"
      else
        flash[:notice] = "Ha habido un problema al crear el viaje"
        render :new
      end
    else
        redirect_to new_viaje_path, notice: "El viaje no puede tener una fecha anterior a la actual"
    end
  end

  def show
    @viaje = Viaje.find(params[:id])
  end

  def update
    @rutas = Ruta.all
    @combis = Combi.all
    @choferes = Usuario.where(rol: "chofer").where(borrado: false)
    @viaje = Viaje.find(params[:id])

    @choferID = @viaje.chofer_id
    if @viaje.update(params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio, :fecha_hora))
      if @viaje.chofer_id != @choferID
        # si cambió de chofer
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
    @choferes = Usuario.where(rol: "chofer").where(borrado: false)
  end

  def destroy
      Viaje.find(params[:id]).destroy
      redirect_to viajes_path
  end
end
