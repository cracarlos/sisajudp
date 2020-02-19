Rails.application.routes.draw do

  devise_for :usuarios
  root 'actas#index'
  resources :juramentados
  resources :actas
  get :generate_pdf, to: "actas#generate_pdf"
  post '/juramentados/traer_cedulados', to: "juramentados#traer_cedulados"
  post '/juramentados/extensiones_sedes', to: "juramentados#extensiones_sedes"
  post '/juramentados/materias', to: "juramentados#materias"
  get 'cerrar_acta/:id', to: 'actas#cerrar_acta', as: 'cerrar_acta'
  get 'actas/abiertas'
  get 'usuarios_sistema', to: 'usuarios_sistema#index'
  get 'usuarios_sistema/new', to: 'usuarios_sistema#new'
  get '/usuarios_sistema/:id/edit', to: 'usuarios_sistema#edit', as: 'usuario_editar'
  get 'usuarios_sistema/:id', to: 'usuarios_sistema#update'
  
end
