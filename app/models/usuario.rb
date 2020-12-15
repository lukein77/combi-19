class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :fecha_nacimiento, presence: true
  validate :validar_edad
  has_and_belongs_to_many :viajes
  has_many :pasajes, dependent: :destroy
  has_many :tarjetas, dependent: :destroy
  has_many :comentarios, dependent: :destroy
  has_one :formulario_covid, dependent: :destroy

  after_initialize :default_values, unless: :persisted?
  before_save :default_values

  def active_for_authentication?
      super && !borrado
  end

  def generate_password
      o =  [('a'..'z'), ('A'..'Z'), (0..9)].map{|i| i.to_a}.flatten
      self.password = self.password_confirmation = (0..16).map{ o[rand(o.length)] }.join if self.password.blank?
  end

  def generate_email
      o = [('a'..'z'), ('A'..'Z'), (0..9)].map{|i| i.to_a}.flatten
      self.email = (0..16).map{o[rand(o.length)]}.join
      self.email = self.email + "@mail.com"
  end

  def default_values
    if self.borrado == nil
      self.borrado = false
    end
  	if self.rol == nil 
    	self.rol = "cliente"
    end
  end


  def validar_edad
    if fecha_nacimiento.present? && fecha_nacimiento > 18.years.ago.to_date
      errors.add(:fecha_nacimiento, "Debe ser mayor de 18 años para registrarse.")
    end
  end

  def validar_fecha_viaje(salida, llegada)
		@viajes = self.viajes
		if not @viajes.empty?
			@viajes.each do |viaje|
				if ((viaje.fecha_hora - 3.hours)..(viaje.fecha_hora_llegada + 3.hours)).overlaps?(salida..llegada)
					return false
				end
			end 
		end
		return true
  end
  
  def current_viaje
    id = 0
    self.viajes.each do |viaje|
      if viaje.en_curso?
        id = viaje.id
        break
      end
    end
    return id
  end

  def agregar_pasajero(pasajero)
    p = Pasaje.new
    p.usuario_id  = pasajero.id
    p.viaje_id = current_viaje
    p.save
    v = Viaje.find(p.viaje_id)
    usuario = Usuario.find(pasajero.id)
    v.usuarios << usuario
    if v.usuarios.size == v.combi.asientos
      v.disponibilidad = "completo"
    end
    v.save
  end
end
