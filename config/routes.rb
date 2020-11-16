Rails.application.routes.draw do

  resources :adicionales
	resources :combis
  resources :rutas
  resources :ciudades

  devise_for :usuarios, controllers: {
    sessions: 'usuarios/sessions',
    registrations: 'usuarios/registrations'
  }

  resources :usuarios, only: [:index, :edit, :update, :show]

  root 'main#index'
end
