class MensajesMailer < ApplicationMailer

  def send_random_password(usuario)
  	@usuario = usuario
  	mail to: usuario.email , subject: "Registro en Combi-19"
  end

end
