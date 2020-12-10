class MensajesMailer < ApplicationMailer

    def send_random_password(usuario)
  	    @usuario = usuario
  	    mail to: usuario.email , subject: "Registro en Combi-19"
    end

    def pasajero_rechazado_email
        @pasaje = Pasaje.find(params[:pasaje_id])
        @usuario = Usuario.find(@pasaje.usuario_id)
        @viaje = Viaje.find(@pasaje.viaje_id)
        mail(to: @usuario.email, subject: "Ha sido rechazado del viaje")
    end
  
end