class ActasController < ApplicationController
  before_action :authenticate_usuario!
  add_flash_types :info, :error, :warning
  def index
    @tacactasFirmantes = TacActa.acta_cerradas
  end

  def new
    begin
      @tacactas = TacActa.last
      @tacfirmantes = TacFirmante.all
      #@tinsedes = TinSede.all Activar cuando este en la DP
      @TiempoHora = Time.now
      
      # ------------------ Correlativo de las Actas -------------------
      
       if @tacactas
         @correlativo = @tacactas.numero_acta + 1    
       end

      if !@tacactas
        @correlativo = 1
      end

    rescue Exception => e
      flash[:error] = "No se pudo conectar con la Base de Datos"
      redirect_to :actas_abiertas
      puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' + e.inspect
    end
    
  end

  def create
    begin  
      @tacactas = TacActa.new(acta)
      @tacactas.save!
      flash[:info] = "Acta Creada" 
      redirect_to :actas_abiertas
    rescue Exception => e
      flash[:error] = "No se pudo guardar" 
      redirect_to :actas_abiertas
      puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' + e.inspect
    end
  end

  def edit
    @tacactas = TacActa.find(params[:id])
	  @tacfirmantes = TacFirmante.all
	  #@tinsedes = TinSede.all  Activar cuando este en la DP
    @tac_compentencias = TacCompetencia.all
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
    begin
      @tacactas = TacActa.find(params[:id])
      @tacactas.destroy
      flash[:info] = "Acta Elminada" 
      redirect_to :actas_abiertas
    rescue Exception => e
      flash[:error] = "No se pudo eliminar" 
      redirect_to :actas_abiertas
      puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' + e.inspect
    end
    
  end

  def generate_pdf
    begin
      @t = Time.now
      @tacactas = TacActa.generar(generar_pdf)
      @anio_letras = TacActa.anio_en_letras(@tacactas[0].para.year)
      @dia_letras = TacActa.anio_en_letras(@tacactas[0].para.day)
      @hora_letras = TacActa.anio_en_letras(@tacactas[0].para.hour)
      #puts '!!!!!!!!!!!!!!!!!!!!!!' + @anio_letras.inspect
      respond_to do |format|
        format.html
        format.pdf do
          render  pdf: 'acta',
               template: 'actas/generate_pdf.pdf.erb'
           end
         end
      rescue Exception => e
        flash[:error] = "Agregue juramentados para poder generar el acta" 
        redirect_to :actas_abiertas
        puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' + e.inspect
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
	  params.require(:acta).permit(:numero_acta,:sede, :tac_firmante_id, :para)
	end

	def acta_edit
	  params.require(:tac_acta).permit(:sede, :tac_firmante_id)
	end

  def generar_pdf
    params.require(:generar)
  end
end
