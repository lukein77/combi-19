class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :fecha_nacimiento, presence: true
  validate :validar_edad

  after_initialize :default_values, unless: :persisted?

  before_save :default_values
  def default_values
  	if self.rol == nil 
    	self.rol = "cliente"
    end
  end

  def validar_edad
    if fecha_nacimiento.present? && fecha_nacimiento > 18.years.ago.to_date
      errors.add(:fecha_nacimiento, "Debe ser mayor de 18 años para registrarse.")
    end
  end

end
