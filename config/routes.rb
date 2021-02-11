Rails.application.routes.draw do

  devise_for :usuarios
  root 'actas#index'
  resources :tac_juramentados
  #resources :actas
  get '/tac_actas', to: "actas#index"
  post '/tac_actas', to: "actas#create"
  get '/tac_actas/new', to: "actas#new"
  get '/tac_actas/:id/edit', to: "actas#edit", as: 'tac_actas_edit'
  put '/tac_actas/:id', to: "actas#update"
  delete '/tac_actas/:id', to: "actas#destroy", as: 'tac_actas_destroy'
  get '/tac_actas/abiertas', to: 'actas#actas_abiertas'
  get '/tac_actas/:id', to: "actas#show", as: 'tac_actas_show'


  





  post '/tac_juramentados/traer_cedulados', to: "tac_juramentados#traer_cedulados"
  get :generate_pdf, to: "actas#generate_pdf"
  post '/tac_juramentados/traer_cedulados', to: "tac_juramentados#traer_cedulados"
  post '/tac_juramentados/extensiones_sedes', to: "tac_juramentados#extensiones_sedes"
  post '/tac_juramentados/:id/extensiones_sedes', to: "tac_juramentados#extensiones_sedes"
  post '/tac_juramentados/materias', to: "tac_juramentados#materias"
  post '/tac_juramentados/:id/materias', to: "tac_juramentados#materias"
  get 'cerrar_acta/:id', to: 'actas#cerrar_acta', as: 'cerrar_acta'
  get 'usuarios_sistema', to: 'usuarios_sistema#index'
  get 'usuarios_sistema/new', to: 'usuarios_sistema#new'
  get '/usuarios_sistema/:id/edit', to: 'usuarios_sistema#edit', as: 'usuario_editar'
  get 'usuarios_sistema/:id', to: 'usuarios_sistema#update'

  #get '*path' => redirect('/public/404.html')
  
end
