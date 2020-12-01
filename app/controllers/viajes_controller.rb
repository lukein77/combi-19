class ViajesController < ApplicationController
  def index
    @viajes = Viaje.order(fecha_hora: :asc).all
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
    @viaje = Viaje.new(viaje_params)

    if @viaje.fecha_hora - Time.now > 1.days
      @viaje.agregarHoraLlegada
      if @viaje.save
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

  def show
    @viaje = Viaje.find(params[:id])
    @chofer = Usuario.find(@viaje.chofer_id)
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
    @viaje = Viaje.find(params[:id])
    if (DateTime.now).between?(@viaje.fecha_hora, @viaje.fecha_hora_llegada)
      flash[:notice] = "No se puede eliminar un viaje en curso."
    else
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
            for i in 1..@adicionales.size-1 do
              a = Adicional.find(@adicionales[i].to_i)
              p.adicionales << a
            end
            p.usuario_id = current_usuario.id
            p.viaje_id = params[:id]
            p.save
            @viaje.usuarios << current_usuario
            redirect_to viajes_path, notice:"La compra se concreto correctamente"
          else
            redirect_to viajes_path, notice:"Ya no quedan pasajes disponibles"
          end
        else
          redirect_to comprar_viaje_path(@viaje), notice: "Ingrese una tarjeta y su clave correspondiente"
        end
      end
  end

  private
  def viaje_params
    params.require(:viaje).permit(:ruta_id, :combi_id, :chofer_id, :precio, :fecha_hora)
  end

end
