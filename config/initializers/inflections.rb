# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|
	inflect.plural 'ciudad', 'ciudades'
	inflect.plural 'ruta', 'rutas'

	inflect.irregular 'ciudad', 'ciudades'
	inflect.irregular 'ruta', 'rutas'

	inflect.singular 'ciudades', 'ciudad'
	inflect.singular 'rutas', 'ruta'

	#Modifico los plurales y singulares para que las rutas
	#funcionen correctamente y queden bien los nombres de
	#las clases
end