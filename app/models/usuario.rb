class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :fecha_nacimiento, presence: true
  validate :validar_edad
  has_and_belongs_to_many :viajes
  has_and_belongs_to_many :pasajes
  has_many :tarjetas, dependent: :destroy
  has_many :comentarios, dependent: :destroy
  has_one :formulario_covid

  after_initialize :default_values, unless: :persisted?
  before_save :default_values

  def active_for_authentication?
      super && !borrado
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
  
end
