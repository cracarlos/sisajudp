Rails.application.routes.draw do

  devise_for :usuarios
  root 'actas#index'
  resources :juramentados
  resources :actas
  get :generate_pdf, to: "actas#generate_pdf"
  post '/juramentados/traer_cedulados', to: "juramentados#traer_cedulados"
  get 'cerrar_acta/:id', to: 'actas#cerrar_acta', as: 'cerrar_acta'
  get 'actas/abiertas'
  
end
