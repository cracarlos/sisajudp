Rails.application.routes.draw do

  devise_for :usuarios
  root 'actas#index'
  resources :juramentados
  resources :actas
  get :generate_pdf, to: "actas#generate_pdf"
  
end
