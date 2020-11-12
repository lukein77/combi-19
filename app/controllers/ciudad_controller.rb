class CiudadController < ApplicationController
  def index
  	@ciudad = Ciudad.all
  end

  def new
  	@ciudad = Ciudad.new
  end

  def create
  	@ciudad = Ciudad.new
  	if @ciudad.save
  		redirect_to ciudad_path, notice: "La ciudad fue creada"
  	else
  		flash[:error] = "Ha habido un problema al crear la ciudad"
  		render :new
  	end
  end

  def destroy
  	Ciudad.find(params[:id]).destroy
  	redirect_to ciudad_path
  end
end
