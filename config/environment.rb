my_rails_root = File.expand_path('../..', __FILE__)

#Desactivo las protecciones de POST en controladores
#config.action_controller.allow_forgery_protection = false

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!