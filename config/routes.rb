Rails.application.routes.draw do

  resources :adicionales
  resources :rutas
  resources :ciudades
  resources :tarjetas
  resources :comentarios
  resources :formulario_covids

  resources :viajes
  get 'viajes/:id/comprar', to: 'viajes#comprar', as: 'comprar_viaje'

	resources :combis
  post 'combis/:id/dar_de_baja', to: 'combis#combi_dar_de_baja', as: 'combi_dar_de_baja'

  devise_for :usuarios, controllers: {
    sessions: 'usuarios/sessions',
    registrations: 'usuarios/registrations'
  }

  get 'usuarios/choferes_index' , to: 'usuarios#choferes_index', as: 'choferes_index'
  get 'usuarios/:id/mostrar_formulario_covid', to: 'usuarios#mostrar_formulario_covid', as: 'mostrar_formulario_covid'
  post 'usuarios/:id/dar_de_baja', to: 'usuarios#chofer_dar_de_baja', as: 'chofer_dar_de_baja'
  resources :usuarios, only: [:index, :edit, :update, :show]

  post 'viajes/:id/cambiar_estado', to: 'viajes#cambiar_estado', as: 'cambiar_estado'

  

  root 'main#index'
end
