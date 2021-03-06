class JuramentadosController < ApplicationController
  before_action :authenticate_usuario!

  def index
    begin
      @tacjuramentados = TacJuramentado.numero_acta
    rescue Exception => e
      flash[:error] = "Problema de Conexión con Bases de Datos" 
      redirect_to :actas
      puts '!!!!!!!!!!!!!!!!!!!' + e.inspect
    end
    
  end

  def new
    begin
      @juramentado = TacJuramentado.new
      @usuarioId = current_usuario.id
      @tac_unidades = TacUnidade.all
      @tac_extensiones_sedes = TacExtensionesSede.all
      @tac_cargos = TacCargo.all
      @tac_competencias = TacCompetencia.all
      @tac_actas = TacActa.numero_acta

    rescue Exception => e
      flash[:error] = "Problema de Conexión con Bases de Datos" 
      redirect_to :juramentados
      puts '!!!!!!!!!!!!!!!!!!!' + e.inspect
      
    end
    
  end

  def create
    begin
      @tacjuramentados = TacJuramentado.new(juramentados_parametros)
      puts juramentados_parametros.inspect
      @tacjuramentados.save
      flash[:info] = "Guardado" 
      redirect_to :juramentados
    rescue Exception => e
      flash[:error] = "No se pudo guardar al Juramentado" 
      puts '!!!!!!!!!!!!!!!!!!!111111111' + e.inspect
      redirect_to :juramentados
    end
  end

  def show
    @tacjuramentados = TacJuramentado.numero_acta
  end

  def edit
  	@tac_juramentados = TacJuramentado.find(params[:id])
    @tac_unidades = TacUnidade.all
    @tac_extensiones_sedes = TacExtensionesSede.all
    @tac_cargos = TacCargo.all
    @tac_competencias = TacCompetencia.all
    @tac_actas = TacActa.numero_acta
    @tac_materias = TacMateria.all

  end

  def update
    begin
      @tacjuramentados = TacJuramentado.find(params[:id])
      @tacjuramentados.update(juramentados_parametros_edit)
      #redirect_to action: 'show', id: @tacjuramentados.id
      flash[:info] = "Guardado" 
      redirect_to :juramentados
    rescue Exception => e
      flash[:error] = "No se pudo modificar al Juramentado" 
      puts '!!!!!!!!!!!!!!!!!!!' + e.inspect
      redirect_to :juramentados
    end	
  end

  def destroy
    begin
      @tacjuramentados = TacJuramentado.find(params[:id])
      @tacjuramentados.destroy
      flash[:info] = "Eliminado" 
      redirect_to :juramentados
    rescue Exception => e
      flash[:error] = "No se pudo eliminar" 
      redirect_to :juramentados
    end
    
  end

  def traer_cedulados
    @cedulados = DatoPersonaV.cedulados(cedulados)
    render json: @cedulados
    #puts @cedulados.to_json
  end

  def extensiones_sedes
    #@extensiones_sedes = TacExtensionesSede.extensiones_sedes(tac_unidade_id)
    @extensiones_sedes = TacExtensionesSede.all
    render json: @extensiones_sedes  
  end

  def materias
    @materias = TacMateria.all
    render json: @materias  
  end

  private
    def juramentados_parametros
      params.require(:acta).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                   :segundo_apellido, :cedula, :cargo, :resolucion, 
                                   :tac_competencia_id, :tac_acta_id,:fecha_resolucion, 
                                   :tac_unidade_id, :tac_extensiones_sedes_id,materias_attributes: [:id, :tac_juramentado_id, :tac_materia_id, :_destroy])
       end

    def juramentados_parametros_edit
      params.require(:tac_juramentado).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                               :segundo_apellido, :cedula, :cargo, :resolucion, 
                                               :tac_competencia_id, :tac_acta_id,:fecha_resolucion, 
                                               :tac_unidade_id, :tac_extensiones_sedes_id,:materias)
    end

    def cedulados
      params.require(:cedula)
    end

    def tac_unidade_id
      params.require(:unidad)
    end


end
