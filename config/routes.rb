Rails.application.routes.draw do
  
  resources :juramentados
  resources :actas
  get :generate_pdf, to: "actas#generate_pdf"
end
