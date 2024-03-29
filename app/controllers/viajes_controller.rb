class ViajesController < ApplicationController
  def index
    @ciudadOrigen = search_params.dig(:ciudadOrigen)
    @ciudadDestino = search_params.dig(:ciudadDestino)

    @fecha_viaje_new = search_params[:fecha_viaje]
    if @fecha_viaje_new.present?
      @fecha_viaje_new = @fecha_viaje_new.first
    else
      @fecha_viaje_new = ""
    end
    # Con el first lo saco del array y guardo solo "YYYY-MM-DD" en lugar de ["YYYY-MM-DD"]

    if (not usuario_signed_in?) or current_usuario.rol == "cliente"
      @estado = "programado"
      @estado_checked = true
      @disponibilidad = "disponible"
      @disponibilidad_checked = true
    else
      @estado = search_params.dig(:estado)
      @estado_checked = search_params.dig(:estado_checked)

      @disponibilidad = search_params.dig(:disponibilidad)
      @disponibilidad_checked = search_params.dig(:disponibilidad_checked)
    end

    #byebug #DEBUG

    # FILTRADO POR CIUDAD DE ORIGEN Y DESTINO
    if (@ciudadOrigen.present? and @ciudadDestino.present?) # Si estan en Nil da false, sino da true
      @ruta = Ruta.where(ciudadOrigen: @ciudadOrigen).where(ciudadDestino: @ciudadDestino)
      @viajes = Viaje.where(ruta: @ruta).order(fecha_hora: :asc)
    elsif(@ciudadOrigen.present?)
      @ruta = Ruta.where(ciudadOrigen: @ciudadOrigen)
      @viajes = Viaje.where(ruta: @ruta).order(fecha_hora: :asc)
    elsif(@ciudadDestino.present?)
      @ruta = Ruta.where(ciudadDestino: @ciudadDestino)
      @viajes = Viaje.where(ruta: @ruta).order(fecha_hora: :asc)
    else
      @viajes = Viaje.order(fecha_hora: :asc).all
    end

    # FILTRADO POR FECHA
    if (@fecha_viaje_new != "")
      @fecha_viaje_new = @fecha_viaje_new.to_date
      @viajes = @viajes & Viaje.where(:fecha_hora => @fecha_viaje_new.beginning_of_day..@fecha_viaje_new.end_of_day)
    end

    # FILTRADO POR ESTADO
    if (@estado_checked) 
      @viajes = @viajes & Viaje.where(estado: @estado).order(fecha_hora: :asc)
    end

    # FILTRADO POR DISPONIBILIDAD
    if (@disponibilidad_checked)
      @viajes = @viajes & Viaje.where(disponibilidad: @disponibilidad).order(fecha_hora: :asc)
    end

    if(@viajes.empty?)
      flash[:notice] = "No se encontraron viajes con los filtros seleccionados"
    end

    @combis = Combi.all
    @ciudades = Ciudad.all
  end

  def new
    @viaje = Viaje.new
    @rutas = Ruta.all
    @combis = Combi.all.where(borrado: false)
    @choferes = Usuario.where(rol: "chofer").where(borrado: false)
  end

  def create
    @rutas = Ruta.all
    @combis = Combi.all.where(borrado: false)
    @choferes = Usuario.where(rol: "chofer").where(borrado: false)

    # El parametro es un string, lo convierto a int
    repetir_dias = repetir_params[:repetir_dias].to_i
    repetir_meses = repetir_params[:repetir_meses].to_i
    repetir_veces = repetir_params[:repetir_veces].to_i

    #byebug
    #combi = @viaje.combi
    #chofer_id = @viaje.chofer_id

    fechas = Array.new
    combi_ocupada = Array.new
    chofer_ocupado = Array.new
    dia_invalido = Array.new

    
    
    # Se le suman dias y meses por i, es decir, por cada vez que se tenga que repetir
    # ej: si se repite cada 10 dias, 3 veces, sera: fecha+1*10; fecha+2*10; fecha+3*10
    @viaje = Viaje.new(viaje_params)
    @viaje.agregar_hora_llegada

    if repetir_veces > 1 # Si pongo repetir 2 veces, crea 2 viajes en TOTAL
      repetir_veces -= 1
    end

    for i in 0..repetir_veces do
      error = false
      if(not @viaje.validar_combi)
        combi_ocupada << @viaje.fecha_hora
        error = true
      end
      if(not @viaje.validar_chofer)
        chofer_ocupado << @viaje.fecha_hora
        error = true
      end
      if(not @viaje.validar_dia)
        dia_invalido << @viaje.fecha_hora
        error = true
      end
      
      if not error
        fechas << @viaje.fecha_hora
      end

      #byebug #VERIFICAR
      if (not (repetir_dias >= 1 or repetir_meses >= 1))
        break # Si solo hace un caso
      end

      @viaje.fecha_hora += repetir_dias.days + repetir_meses.months
      @viaje.agregar_hora_llegada

    end
     
    if chofer_ocupado.empty? and combi_ocupada.empty? and dia_invalido.empty?
      fechas.each do |f|
        @viaje = Viaje.new(viaje_params)
        @viaje.fecha_hora = f
        @viaje.agregar_hora_llegada
        if @viaje.save
          @viaje.agregar_viaje_a_chofer
        else
          flash[:notice] = "Ha habido un problema al crear el viaje"
          render :new
          break
        end
      end

      if(fechas.count > 1)
        redirect_to viajes_path, notice: "Los viajes fueron creados"
      else
        redirect_to viajes_path, notice: "El viaje fue creado"
      end

    else 
      render :new

		end

  end

  def show
    @viaje = Viaje.find(params[:id])
    @chofer = Usuario.find(@viaje.chofer_id)

    @tiene_viaje = current_usuario.viaje_ids.include?(@viaje.id)
    
    @comentarios = @viaje.comentarios.order(created_at: :desc)
    @comentario = Comentario.new
  end

  def update
    @rutas = Ruta.all
    @combis = Combi.all.where(borrado: false)
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
    @combis = Combi.all.where(borrado: false)
    @choferes = Usuario.where(rol: "chofer").where(borrado: false)
  end

  def destroy
    @viaje = Viaje.find(params[:id])
    if DateTime.now.between?(@viaje.fecha_hora, @viaje.fecha_hora_llegada)
      flash[:notice] = "No se puede eliminar un viaje en curso."
    else
      @chofer = Usuario.find(@viaje.chofer_id)
      @chofer.viajes.destroy(@viaje)
      #@viaje.combi.viajes.destroy(@viaje)
      @viaje.destroy
      flash[:notice] = "El viaje fue eliminado."
    end
    redirect_to viajes_path
  end

  def precio_compra
    params.permit(:adicionales)
    @viaje= Viaje.find(params[:id])
    precio = @viaje.precio
    if @adicionales.present?
      for i in 1..@adicionales.size-1 do
        a = Adicional.find(@adicionales[i].to_i)
        precio = precio + a.precio;
      end
    end
    return precio
  end

  def cancelar_pasaje
    viaje = Viaje.find(params[:id])
    #usuarioID = params[:usuario_id]
    usuarioID = current_usuario.id
    pasaje = viaje.pasajes.find_by(usuario_id: usuarioID)
    
    pasaje.estado = "cancelado"
    #viaje.usuarios.delete(usuarioID)
    viaje.disponibilidad = "disponible" # En el caso de que estuviera completo

    if(pasaje.save and viaje.save)
      MensajesMailer.pasaje_cancelado(viaje, current_usuario, pasaje).deliver_now
    end

    redirect_to usuario_path(usuarioID), notice: "El viaje fue cancelado exitosamente"
  end

  def crear_pasaje
    @viaje = Viaje.find(params[:id])
    @adicionales = params.dig(:adis)
    p=Pasaje.new
    if @adicionales.present?
      for i in 1..@adicionales.size-1 do
        a = Adicional.find(@adicionales[i].to_i)
        p.adicionales << a
      end
    end
    p.usuario_id = current_usuario.id
    p.viaje_id = params[:id]
    p.save
    @viaje.usuarios << current_usuario
    if @viaje.usuarios.size == @viaje.combi.asientos
      @viaje.disponibilidad = "completo"
    end
    @viaje.save
  end

  def comprar
    params.permit(:tarjeta, :adicionales)
    @viaje = Viaje.find(params[:id])
    @tarjeta = params[:tarjeta]
    @adicionales = params.dig(:adicionales,:ids)
    @clave = params[:clave]
    @commit = params[:commit]
    @compra = params[:compra]
    @adi = params.dig(:adis)
    @precio_compra = precio_compra
    if @compra.present?
      if @tarjeta.present? and @clave.present?
        if Tarjeta.find(@tarjeta.to_i).numero % 2 == 0
          if @viaje.usuarios.size <= @viaje.combi.asientos
            crear_pasaje
            redirect_to viajes_path, notice:"La compra se concretó correctamente"
          else
            redirect_to viajes_path, notice:"Ya no quedan pasajes disponibles"
          end
        else
            flash[:notice] = "La tarjeta no contiene saldo suficiente"
        end
      else
        flash[:notice] = "Ingrese una tarjeta y su clave correspondiente"
      end
    end
  end
  
  def cambiar_estado
    @viaje = Viaje.find(params[:id])
    @chofer = Usuario.find(@viaje.chofer_id)
    if @viaje.programado?
      @viaje.estado = "en_curso"
    elsif @viaje.en_curso?
      @viaje.estado = "finalizado"
      @viaje.pasajes.aceptado.each do |pasaje|
        pasaje.estado = "finalizado"
        pasaje.save
      end
    end
    if not @viaje.save
      flash[:notice] = "Hubo un error al procesar la solicitud."
    end
    redirect_to viaje_path(@viaje)
  end

  def aceptar_pasajero
    @viaje = Viaje.find(params[:viaje_id])
    @pasaje = @viaje.pasajes.find_by(usuario_id: params[:usuario_id])
    @pasaje.estado = "aceptado"
    if @pasaje.save
      flash[:notice] = "Usuario aceptado"
    else
      flash[:notice] = "Hubo un error al aceptar el pasajero."
    end
    redirect_to viaje_path(@viaje)
  end

  def motivo_rechazo_pasajero
    # GET
    @viaje = Viaje.find(params[:viaje_id])
    @pasaje = @viaje.pasajes.find_by(usuario_id: params[:usuario_id])
  end

  def rechazar_pasajero
    # POST
    @viaje = Viaje.find(params[:viaje_id])
    @usuarioID = params[:usuario_id]
    @pasaje = @viaje.pasajes.find_by(usuario_id: @usuarioID)

    @pasaje.estado = params[:estado]
    if @pasaje.save
      MensajesMailer.with(pasaje_id: @pasaje.id).pasajero_rechazado_email.deliver_now
      flash[:notice] = "Usuario rechazado"
      redirect_to viaje_path(@viaje.id)
    else
      flash[:notice] = "Hubo un error al rechazar el pasajero."
      redirect_to viaje_path(@viaje.id)
    end
  end

  def cancelar
    viaje = Viaje.find(params[:viaje_id])
    viaje.estado = "cancelado"
    viaje.usuarios.each do |usuario|
      #NO ENTRA AL FOR ESTE
      if usuario.rol != "chofer"
        p = viaje.pasajes.find_by(usuario_id: usuario.id)
        if p.estado != "cancelado" # Si no habia cancelado el pasaje el usuario
          MensajesMailer.viaje_cancelado(viaje, usuario, p).deliver_now
          p.estado = "cancelado"
          p.save
        end
      end
    end
    viaje.save
    redirect_to viajes_path , notice: "El viaje fue cancelado"
  end

  def viajes_a_cancelar # Solo le paso a la vista los viajes programados a mostrar
    @viajes = Viaje.where(estado: "programado").order(fecha_hora: :asc)
  end

  private
  def viaje_params
    params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, 
                                  :precio, :fecha_hora)
  end

  def repetir_params
    params.permit(:repetir_dias, :repetir_meses, :repetir_veces)
  end

  private
  def search_params
    #params.permit(search: {})
    params.permit(:ciudadOrigen, :ciudadDestino,
                  :estado, :estado_checked,
                  :disponibilidad, :disponibilidad_checked,
                  :fecha_viaje => [])
  end
end
