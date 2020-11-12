class AdicionalesController < ApplicationController
  def index
  end

  def show
  end

  def new
    @adicional = Adicional.new
  end

  def create
    @adicional = Adicional.new(params.require(:adicional).permit(:nombre, :descripcion, :precio))
    if @adicional.save
      redirect_to adicionales_path
    else
      
      render :new
    end
  end

  def edit
  end

  def destroy
  end
end
