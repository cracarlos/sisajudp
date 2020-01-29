class UsuariosController < ApplicationController
	before_action :authenticate_usuario!

	def index
		@usuarios = Usuario.all
		@a1 = 'asd'
	end

	def new
		@tinusuarios = TinUsuario.where(estatus: 'A')
	end
end