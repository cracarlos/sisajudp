class TacJuramentadosController < ApplicationController
  before_action :authenticate_usuario!
  skip_before_action :verify_authenticity_token # Me permite hacer los llamados ajax (Investigar porque dejaron de funcionar)

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
      @tac_unidades = TacUnidade.order(:coordinaciones_regionales)
      #@tac_extensiones_sedes = TacExtensionesSede.all
      @tac_cargos = TacCargo.order(:cargos)
      @tac_competencias = TacCompetencia.order(:competencia)
      @tac_actas = TacActa.numero_acta

    rescue Exception => e
      flash[:error] = "Problema de Conexión con Bases de Datos" 
      redirect_to :tac_juramentados
      puts '!!!!!!!!!!!!!!!!!!!' + e.inspect
      
    end
    
  end

  def create
    begin
      @tacjuramentados = TacJuramentado.new(juramentados_parametros)
      puts '111111111111111111111' + juramentados_parametros.inspect
      puts '22222222222222222222' + @tacjuramentados.inspect
      @tacjuramentados.save(validate: false)
      puts '33333333333333333333' + @tacjuramentados.save.inspect
      flash[:info] = "Guardado" 
      redirect_to :tac_juramentados
    rescue Exception => e
      flash[:error] = "No se pudo guardar al Juramentado" 
      puts '!!!!!!!!!!!!!!!!!!!111111111' + e.inspect
      redirect_to :tac_juramentados
    end
  end

  def show
    #@tacjuramentados = TacJuramentado.numero_acta
    #@tacjuramentado = TacJuramentado.find(params[:id])
    @tacjuramentado = TacJuramentado.juramentados_detalles(params[:id])
    puts'1111111111111111111111111' + @tacjuramentado.inspect
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
      @tacjuramentados = TacJuramentado.find(juramentado)
      @tacjuramentados.update(juramentados_parametros_edit)
      #redirect_to action: 'show', id: @tacjuramentados.id
      flash[:info] = "Guardado" 
      redirect_to :tac_juramentados
    rescue Exception => e
      flash[:error] = "No se pudo modificar al Juramentado" 
      puts '!!!!!!!!!!!!!!!!!!!' + e.inspect
      redirect_to :tac_juramentados
    end	
  end

  def destroy
    begin
      @tacjuramentados = TacJuramentado.find(juramentado)
      puts '¡¡¡¡¡¡DESTROY!!!!!' + @tacjuramentados.inspect
      @tacjuramentados.destroy
      puts '¡¡¡¡¡¡DESTROY!!!!! 222' + @tacjuramentados.destroy.inspect
      flash[:info] = "Eliminado" 
      redirect_to :tac_juramentados
    rescue Exception => e
      puts '¡¡¡¡¡DETALES DEL ERROR!!!!!' + e.inspect
      flash[:error] = "No se pudo eliminar" 
      redirect_to :tac_juramentados
    end
    
  end

  def traer_cedulados
    @cedulados = DatoPersonaV.cedulados(cedulados)
    render json: @cedulados
    #puts @cedulados.to_json
  end

  def extensiones_sedes
    #@extensiones_sedes = TacExtensionesSede.extensiones_sedes(tac_unidade_id)
    @extensiones_sedes = TacExtensionesSede.order(:coordinaciones_extensiones)
    render json: @extensiones_sedes  
  end

  def materias
    @materias = TacMateria.order(:materia)
    render json: @materias  
  end

  private
    def juramentados_parametros
      params.require(:tac_juramentado).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                   :segundo_apellido, :cedula, :tac_cargo_id, :resolucion, 
                                   :tac_competencia_id, :tac_acta_id,:fecha_resolucion, 
                                   :tac_unidade_id, :tac_extensiones_sedes_id,:cargo_letras, :cargo_numero,tac_juramentado_materias_attributes: [:id, :tac_juramentado_id, :tac_materia_id, :_destroy]
                                   )
       end

    def juramentados_parametros_edit
      params.require(:tac_juramentado).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                               :segundo_apellido, :cedula, :tac_cargo_id, :resolucion, 
                                               :tac_competencia_id, :tac_acta_id,:fecha_resolucion, 
                                               :tac_unidade_id, :tac_extensiones_sedes_id,:cargo_letras, :cargo_numero,tac_juramentado_materias_attributes: [:id, :tac_juramentado_id, :tac_materia_id, :_destroy],
                                               )
    end

    def cedulados
      params.require(:cedula)
    end

    def tac_unidade_id
      params.require(:unidad)
    end

    def juramentado
      params.require(:id)
    end


end
