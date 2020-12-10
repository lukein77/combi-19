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
    @viaje = Viaje.new(viaje_params)

    repetir_dias = repetir_params[:repetir_dias]
    repetir_meses = repetir_params[:repetir_meses]
    repetir_veces = repetir_params[:repetir_veces]

    byebug
    #combi = @viaje.combi
    #chofer_id = @viaje.chofer_id

    fechas << @viaje.fecha_hora
    # Necesito ingresar si o si cada cuanto se repite (dias o meses o ambas) y cuantas veces se repetira
    if repetir_veces and (repetir_dias or repetir_meses)
      # Se le suman dias y meses por i, es decir, por cada vez que se tenga que repetir
      # ej: si se repite cada 10 dias, 3 veces, sera: fecha+1*10; fecha+2*10; fecha+3*10
      for i in 1..repetir_veces do
        if(validar_combi and validar_chofer)  
          fechas << @viaje.fecha_hora + (repetir_dias.days + repetir_meses.months) * i
        elsif(not validar_combi)
          combi_ocupada << @viaje.fecha_hora + (repetir_dias.days + repetir_meses.months) * i
        else # not validar_chofer
          chofer_ocupado << @viaje.fecha_hora + (repetir_dias.days + repetir_meses.months) * i
        end
      end
    end

          
    if chofer_ocupado.empty? and combi_ocupada.empty?
      fechas.each do |f|
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
          @viaje.errors.add(:fecha_hora, "El horario del viaje debe ser al menos 24hs desde ahora")
          render :new
        end
      end

    elsif(not chofer_ocupado.empty?)
      chofer_ocupado.each do |o|
        @viaje.errors.add(o, "El chofer no se encuentra disponible en esta fecha y hora")
      end

    else #not combi_ocupada.empty?)
      combi_ocupada.each do |o|
        @viaje.errors.add(o, "La combi no se encuentra disponible en esta fecha y hora")
      end
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
      @viaje.combi.viajes.destroy(@viaje)
      @viaje.destroy
    end
    redirect_to viajes_path
  end

  def comprar
      params.permit(:tarjeta, :adicionales)
      @viaje = Viaje.find(params[:id])
      @tarjeta = params[:tarjeta]
      @adicionales = params.dig(:adicionales,:ids)
      @clave = params[:clave]
      @commit = params[:commit]
      if @commit.present?
        if @tarjeta.present? and @clave.present?
          if @viaje.usuarios.size <= @viaje.combi.asientos
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
              @viaje.save
            end
            redirect_to viajes_path, notice:"La compra se concreto correctamente"
          else
            redirect_to viajes_path, notice:"Ya no quedan pasajes disponibles"
          end
        else
          redirect_to comprar_viaje_path(@viaje), notice: "Ingrese una tarjeta y su clave correspondiente"
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
    end
    if not @viaje.save
      flash[:notice] = "salió mal"
    end
    redirect_to viaje_path(@viaje)
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
