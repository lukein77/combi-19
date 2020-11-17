Rails.application.routes.draw do

  resources :adicionales
	resources :combis
  resources :rutas
  resources :ciudades
  resources :viajes

  devise_for :usuarios, controllers: {
    sessions: 'usuarios/sessions',
    registrations: 'usuarios/registrations'
  }

  get 'usuarios/choferes_index' , to: 'usuarios#choferes_index', as: 'choferes_index'
  resources :usuarios, only: [:index, :edit, :update, :show]

  root 'main#index'
end
