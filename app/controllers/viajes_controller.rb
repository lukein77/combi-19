class ViajesController < ApplicationController
  def index
    @ciudadOrigen = search_params.dig(:ciudadOrigen)
    @ciudadDestino = search_params.dig(:ciudadDestino)
    
    if (@ciudadOrigen.present? and @ciudadDestino.present?) # Si estan en Nil da false, sino da true
      @ruta = Ruta.where(ciudadOrigen: @ciudadOrigen).where(ciudadDestino: @ciudadDestino)
      @viajes = Viaje.where(ruta: @ruta)
    elsif(@ciudadOrigen.present?)
      @ruta = Ruta.where(ciudadOrigen: @ciudadOrigen)
      @viajes = Viaje.where(ruta: @ruta)    
    elsif(@ciudadDestino.present?)
      @ruta = Ruta.where(ciudadDestino: @ciudadDestino)
      @viajes = Viaje.where(ruta: @ruta)
    else
      @viajes = Viaje.order(fecha_hora: :asc).all
    end
 

    #byebug #DEBUGEAR
=begin
    if(ciudadOrigen != "")
      @ruta = Ruta.where(ciudadOrigen: ciudadOrigen)
      @viajes = Viaje.where(ruta: @ruta)
    else
      @viajes = Viaje.order(fecha_hora: :asc).all
      @rutas = Ruta.all
    end

=end
    @combis = Combi.all
    @ciudades = Ciudad.all
  end

  def search_params
    #params.permit(search: {})
    params.permit(:ciudadOrigen, :ciudadDestino)
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
    @viaje = Viaje.new(viaje_params)

    #DEBUG
    @viaje.fecha_hora = 2.days.from_now
    #DEBUG

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
    if @viaje.update(viaje_params)
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

  private
  def viaje_params
    #params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio, :fecha_hora)

    #DEBUG
    params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio)
    #DEBUG
  end
end
