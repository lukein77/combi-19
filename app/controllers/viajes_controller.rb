class ViajesController < ApplicationController
  def index
    @ciudadOrigen = search_params.dig(:ciudadOrigen)
    @ciudadDestino = search_params.dig(:ciudadDestino)

    @fecha_viaje = search_params.dig(:fecha_viaje)
    @fecha_checked = search_params.dig(:fecha_checked)

    @estado = search_params.dig(:estado)
    @estado_checked = search_params.dig(:estado_checked)

    @disponibilidad = search_params.dig(:disponibilidad)
    @disponibilidad_checked = search_params.dig(:disponibilidad_checked)

    #byebug #DEBUG

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

    # FILTRADO POR FECHA
    if (@fecha_checked and (not @estado_checked) and (not @disponibilidad_checked))
      temp = []

      @viajes.each do |viaje|
        if (viaje.fecha_hora.year == @fecha_viaje.year and
          viaje.fecha_hora.yday == @fecha_viaje.yday) # yday = dia del año (1 a 365)

        temp << viaje # Los viajes que caen en ese dia se agregan a temp
        end
      @viajes = temp # Muestro solo los viajes de temp
      end
    end


    # FILTRADO POR ESTADO
    if (@estado_checked and (not @disponibilidad_checked) and (not @fecha_checked)) 
      @viajes = Viaje.where(estado: @estado)
    end

    # FILTRADO POR DISPONIBILIDAD
    if (@disponibilidad_checked and (not @estado_checked) and (not @fecha_checked))
      @viajes = Viaje.where(disponibilidad: @disponibilidad)
    end

    @combis = Combi.all
    @ciudades = Ciudad.all
  end

  def search_params
    #params.permit(search: {})
    params.permit(:ciudadOrigen, :ciudadDestino,
                  :fecha_checked, :fecha_viaje,
                  :estado, :estado_checked,
                  :disponibilidad, :disponibilidad_checked)
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

    if @viaje.fecha_hora - Time.now > 1.days
      @viaje.agregar_hora_llegada
      if @viaje.save
        @viaje.agregar_viaje_a_chofer
        redirect_to viajes_path, notice: "El viaje fue creado"
      else
        flash[:notice] = "Ha habido un problema al crear el viaje"
        render :new
      end
    else
      @viaje.errors.add(:fecha_hora, "El viaje no puede tener una fecha anterior a la actual")
      render :new
    end
  end

  def show
    @viaje = Viaje.find(params[:id])
    @chofer = Usuario.find(@viaje.chofer_id)
    if current_usuario.id == @viaje.chofer_id
      @asignado = true
    else
      @asignado = false
    end
  end

  def update
    @rutas = Ruta.all
    @combis = Combi.all
    @choferes = Usuario.where(rol: "chofer").where(borrado: false)
    @viaje = Viaje.find(params[:id])
    
    @choferID = @viaje.chofer_id

    if @viaje.update(viaje_params)
      # me fijo si cambió de chofer
      if @viaje.chofer_id != @choferID
        Usuario.find(@choferID).viajes.destroy(@viaje)
        @viaje.agregar_viaje_a_chofer
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
    @viaje = Viaje.find(params[:id])
    if DateTime.now.between?(@viaje.fecha_hora, @viaje.fecha_hora_llegada)
      flash[:notice] = "No se puede eliminar un viaje en curso."
    else
      @chofer = Usuario.find(@viaje.chofer_id)
      @chofer.viajes.destroy(@viaje)
      @viaje.combi.viajes.destroy(@viaje)
      @viaje.destroy
    end
    redirect_to viajes_path
  end

  def cambiar_estado
    @viaje = Viaje.find(params[:id])
    @chofer = Usuario.find(@viaje.chofer_id)
    if @viaje.programado?
      @viaje.estado = "en_curso"
    elsif @viaje.en_curso?
      @viaje.estado = "finalizado"
    end
    if not @viaje.save
      flash[:notice] = "salió mal"
    end
    redirect_to viaje_path(@viaje)
  end

  private
  def viaje_params
    params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio, :fecha_hora)

    #DEBUG
    #params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio)
    #DEBUG
  end
end
