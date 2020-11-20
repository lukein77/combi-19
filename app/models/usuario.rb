class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :fecha_nacimiento, presence: true
  validate :validar_edad
  has_and_belongs_to_many :viajes

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

end
