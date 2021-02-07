Rails.application.routes.draw do

  resources :adicionales
  resources :rutas
  resources :ciudades
  resources :tarjetas
  resources :comentarios

  #get 'formulario_covids/show/:id/:viaje_id', to: 'formulario_covids#show', as: 'formulario_covid'
  resources :formulario_covids#, only: [:new, :create, :edit, :update]

  resources :viajes
  get 'viajes/:id/comprar', to: 'viajes#comprar', as: 'comprar_viaje'
  get 'viajes/:id/cancelar_pasaje', to: 'viajes#cancelar_pasaje', as: 'cancelar_pasaje'
  post 'viajes/:id/cambiar_estado', to: 'viajes#cambiar_estado', as: 'cambiar_estado'
  post 'viajes/:viaje_id/aceptar_pasajero/:usuario_id', to: 'viajes#aceptar_pasajero', as: 'aceptar_pasajero'
  #get 'viajes/:viaje_id/rechazar_pasajero/:usuario_id', to: 'viajes#motivo_rechazo_pasajero', as: 'motivo_rechazo_pasajero'
  post 'viajes/:viaje_id/rechazar_pasajero/:usuario_id/:estado', to: 'viajes#rechazar_pasajero', as: 'rechazar_pasajero'
  get 'viajes/:viaje_id/cancelar', to: 'viajes#cancelar', as: 'cancelar_viaje'
  get 'viajes/:id/viajes_a_cancelar', to: 'viajes#viajes_a_cancelar', as: 'viajes_a_cancelar'

	resources :combis
  post 'combis/:id/dar_de_baja', to: 'combis#combi_dar_de_baja', as: 'combi_dar_de_baja'

  devise_for :usuarios, controllers: {
    sessions: 'usuarios/sessions',
    registrations: 'usuarios/registrations'
  }

  get 'usuarios/choferes_index' , to: 'usuarios#choferes_index', as: 'choferes_index'
  get 'usuarios/:id/mostrar_formulario_covid/:viaje_id', to: 'usuarios#mostrar_formulario_covid', as: 'mostrar_formulario_covid'
  post 'usuarios/:id/dar_de_baja', to: 'usuarios#chofer_dar_de_baja', as: 'chofer_dar_de_baja'
  get 'usuarios/:id/eliminar_cuenta', to: 'usuarios#eliminar_cuenta', as: 'eliminar_cuenta'
  get 'usuarios/:id/eliminar_cuenta_con_pasajes',to: 'usuarios#eliminar_cuenta_con_pasajes', as: 'eliminar_cuenta_con_pasajes'
  resources :usuarios, only: [:index, :edit, :update, :show]

  
  

  root 'main#index'
end
