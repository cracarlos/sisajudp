class ActasController < ApplicationController
	def index
		@tacactas = TacActa.all
		#@probando = TacActa.find_by(numero_acta:2)
		
	end
	def new
	  @tacactas = TacActa.all
	  @tacfirmantes = TacFirmante.all
	  @tinsedes = TinSede.all
		
	end

	def create
	  @tacactas = TacActa.new(acta)
      if @tacactas.save
        redirect_to action: 'show', id: @tacactas.id
      else
        redirect_to action: 'index'
      end
		
	end

	def edit
	  @tacactas = TacActa.find(params[:id])
	  @tacfirmantes = TacFirmante.all
	  @tinsedes = TinSede.all
	end

	def update
	  @tacactas = TacActa.find(params[:id])
	  if @tacactas.update(acta_edit)
	  	redirect_to action: 'show', id: @tacactas.id
	  end
	end

	def show
	  @tacactas = TacActa.all
	end

	def destroy
	  puts '11111111111111111111111', @tacactas.inspect
      @tacactas = TacActa.find(params[:id])
      puts '2222222222222222222222', @tacactas.inspect
      @tacactas.destroy
      redirect_to acta_path
    end

	def generate_pdf
    @t = Time.now
    @tacprejuramentados = TacPreJuramentado.all
    @tacactas = TacActa.all
    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: 'nombre_del_documento',
             template: 'actas/generate_pdf.pdf.erb'
         end
       end

    end

	private
	  def acta
	  	params.require(:acta).permit(:sede, :id_firmante)
	  end

	  def acta_edit
	  	params.require(:tac_acta).permit(:sede, :id_firmante)
	  end

end
