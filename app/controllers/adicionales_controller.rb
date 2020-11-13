class AdicionalesController < ApplicationController
  def index
    @adicionales = Adicional.all
  end

  def new
    @adicional = Adicional.new
  end

  def create
    @adicional = Adicional.new(params.require(:adicional).permit(:nombre, :descripcion, :precio))
    if @adicional.save
      redirect_to adicionales_path, notice: "El adicional fue creado exitosamente."
    else
      flash[:error] = "Ha habido un problema al crear el adicional."
      render :new
    end
  end

  def edit
    @adicional = Adicional.find(params[:id])
  end

  def update
    @adicional = Adicional.find(params[:id])
    if @adicional.update(params.require(:adicional).permit(:nombre, :descripcion, :precio))
      redirect_to adicionales_path, notice: "Se ha modificado el adicional."
    else
      flash[:error] = "Ha habido un problema al modificar el adicional."
      render :edit
    end
  end

  def destroy
    Adicional.find(params[:id]).destroy
    redirect_to adicionales_path
  end
end
