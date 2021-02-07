class MensajesMailer < ApplicationMailer

    def send_random_password(usuario)
  	    @usuario = usuario
  	    mail to: usuario.email , subject: "Registro en Combi-19"
    end

    def pasajero_rechazado_email
        @pasaje = Pasaje.find(params[:pasaje_id])
        @usuario = Usuario.find(@pasaje.usuario_id)
        @viaje = Viaje.find(@pasaje.viaje_id)
        
        @nombre = @usuario.nombre
        @ruta_nombre = @viaje.ruta.nombre
        @fecha = @viaje.fecha_hora
        mail to: @usuario.email, subject: "Ha sido rechazado del viaje"
    end

    def viaje_cancelado(viaje, usuario, pasaje)
        @nombre = usuario.nombre
        @rol = usuario.rol
        @fecha = viaje.fecha_hora
        @precio = viaje.precio
        @ruta_nombre = viaje.ruta.nombre

        @costo_adicionales = 0
        pasaje.adicionales.each do |adicional|
            @costo_adicionales += adicional.precio
        end

        mail to: usuario.email, subject: "Su viaje ha sido cancelado"
    end

    def pasaje_cancelado(viaje, usuario, pasaje)
        @nombre = usuario.nombre
        @fecha = viaje.fecha_hora
        @precio = viaje.precio
        @ruta_nombre = viaje.ruta.nombre

        @costo_adicionales = 0
        pasaje.adicionales.each do |adicional|
            @costo_adicionales += adicional.precio
        end

        mail to: usuario.email, subject: "Has cancelado un viaje"
    end
end