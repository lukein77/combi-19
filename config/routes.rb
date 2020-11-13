Rails.application.routes.draw do
  
  
  resources :adicionales

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

	resources :combis
  resources :rutas
  resources :ciudades

  devise_for :usuarios, controllers: {
    sessions: 'usuarios/sessions',
    registrations: 'usuarios/registrations'
  }
  
  root 'main#index'
end
