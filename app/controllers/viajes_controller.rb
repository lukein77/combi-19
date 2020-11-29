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
  end
end
