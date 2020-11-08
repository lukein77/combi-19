Rails.application.routes.draw do
  devise_for :usuarios, controllers: {
    sessions: 'usuarios/sessions',
    registrations: 'usuarios/registrations'
  }
  

  root 'main#index'
end
