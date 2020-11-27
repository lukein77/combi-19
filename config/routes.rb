Rails.application.routes.draw do

  resources :adicionales
	resources :combis
  resources :rutas
  resources :ciudades
  resources :viajes
  resources :tarjetas

  devise_for :usuarios, controllers: {
    sessions: 'usuarios/sessions',
    registrations: 'usuarios/registrations'
  }

  get 'usuarios/choferes_index' , to: 'usuarios#choferes_index', as: 'choferes_index'
  post 'usuarios/:id/dar_de_baja', to: 'usuarios#dar_de_baja', as: 'dar_de_baja'
  resources :usuarios, only: [:index, :edit, :update, :show]

  root 'main#index'
end
