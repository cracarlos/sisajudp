class UsuariosSistemaController < ApplicationController
	before_action :authenticate_usuario!

	def index
		@usuarios = Usuario.all
	end

	def new
		@tinusuarios = TinUsuario.where(estatus: 'A')
	end

	def edit
		@tinusuarios = TinUsuario.find(params[:id])
	end

	def update
		@usuarios = Usuario.find(params[:id])

		if @usuarios.update(rol)
      		redirect_to action: 'index', id: @usuarios.id
    	else
      		render 'edit'
    	end	
	end

	private
		def rol
			params.require(:rol)	
		end
end