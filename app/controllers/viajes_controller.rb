class ViajesController < ApplicationController
  def index
    @ciudadOrigen = search_params.dig(:ciudadOrigen)
    @ciudadDestino = search_params.dig(:ciudadDestino)
    @fecha_checked = search_params.dig(:fecha_checked)
    @fecha_viaje = search_params.dig(:fecha_viaje)
    @estado = search_params.dig(:estado)
    @disponibilidad = search_params.dig(:disponibilidad)

    #byebug #DEBUGEAR

    # FILTRADO POR CIUDAD DE ORIGEN Y DESTINO
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

    #UNUSED @viajes = @viajes.where("fecha_hora >": @fecha_viaje) si la fecha pasada es menor que la de la db

    # FILTRADO POR ESTADO Y DISPONIBILIDAD
    @viajes = Viaje.where(estado: @estado)
    @viajes = Viaje.where(disponibilidad: @disponibilidad)

    # FILTRADO POR FECHA
    if(@fecha_checked)
      temp = []

      @viajes.each do |viaje|
        if (viaje.fecha_hora.year == @fecha_viaje.year and
          viaje.fecha_hora.yday == @fecha_viaje.yday) # yday = dia del año (1 a 365)

        temp << viaje # Los viajes que caen en ese dia se agregan a temp
        end
      @viajes = temp # Muestro solo los viajes de temp
      end
    end



    @combis = Combi.all
    @ciudades = Ciudad.all
  end

  def search_params
    #params.permit(search: {})
    params.permit(:ciudadOrigen, :ciudadDestino, :fecha_checked, :fecha_viaje, :estado, :disponibilidad)
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
