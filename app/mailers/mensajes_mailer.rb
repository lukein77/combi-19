class MensajesMailer < ApplicationMailer
    def pasajero_rechazado_email
        @pasaje = Pasaje.find(params[:pasaje_id])
        @usuario = Usuario.find(@pasaje.usuario_id)
        @viaje = Viaje.find(@pasaje.viaje_id)
        mail(to: @usuario.email, subject: "Ha sido rechazado del viaje")
    end
end
