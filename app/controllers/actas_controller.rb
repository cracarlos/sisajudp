class ActasController < ApplicationController
  before_action :authenticate_usuario!
  def index
    @tacactasFirmantes = TacActa.acta_cerradas
  end

  def new
    @tacactas = TacActa.all
	  @tacfirmantes = TacFirmante.all
	  @tinsedes = TinSede.all
    @TiempoHora = Time.now 
  end

  def create
    @tacactas = TacActa.new(acta)
    if @tacactas.save!
      redirect_to action: 'show', id: @tacactas.id
    else
      redirect_to action: 'new'
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
    @tacactasFirmantes = TacActa.acta_abiertas
  end

  def destroy
    @tacactas = TacActa.find(params[:id])
    @tacactas.destroy
    redirect_to acta_path
  end

  def generate_pdf
    @t = Time.now
    @tacactas = TacActa.generar(generar_pdf)
    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: 'acta',
             template: 'actas/generate_pdf.pdf.erb'
         end
       end
  end

  def cerrar_acta
    @tacactas = TacActa.find(params[:id])
    if @tacactas.update_attribute(:estatus, false)
      redirect_to action: 'index'
    else 
      redirect_to action: 'new'
    end
  end

  def actas_abiertas
    @tacactasFirmantes = TacActa.acta_abiertas
  end

  private
    def acta
	  params.require(:acta).permit(:sede, :tac_firmante_id, :para)
	end

	def acta_edit
	  params.require(:tac_acta).permit(:sede, :tac_firmante_id)
	end

  def generar_pdf
    params.require(:generar)
  end
end
