class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_initialize :default_values, unless: :persisted?

  before_save :default_values
  def default_values
  	if self.rol == nil 
    	self.rol = "cliente"
    end
  end

end
