Rails.application.routes.draw do

  resources :adicionales
	resources :combis
  resources :rutas
  resources :ciudades
  resources :tarjetas
  resources :viajes

  get 'viajes/:id/comprar', to: 'viajes#comprar', as: 'comprar_viaje'

  devise_for :usuarios, controllers: {
    sessions: 'usuarios/sessions',
    registrations: 'usuarios/registrations'
  }

  get 'usuarios/choferes_index' , to: 'usuarios#choferes_index', as: 'choferes_index'
  post 'usuarios/:id/dar_de_baja', to: 'usuarios#dar_de_baja', as: 'dar_de_baja'
  resources :usuarios, only: [:index, :edit, :update, :show]

  post 'viajes/:id/cambiar_estado', to: 'viajes#cambiar_estado', as: 'cambiar_estado'

  root 'main#index'
end
