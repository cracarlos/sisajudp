class JuramentadosController < ApplicationController
  before_action :authenticate_usuario!

  def index
    @tacjuramentados = TacJuramentado.numero_acta
  end

  def new
    @tac_unidades = TacUnidade.all
    @tac_extensiones_sedes = TacExtensionesSede.all
    @tac_cargos = TacCargo.all
    @tac_competencias = TacCompetencia.all
    @tac_actas = TacActa.numero_acta
  end

  def create
    @tacjuramentados = TacJuramentado.new(juramentados_parametros)
    if @tacjuramentados.save
      redirect_to action: 'index', id: @tacjuramentados.id
    else
      render 'new'
    end	
  end

  def show
    @tacjuramentados = TacJuramentado.numero_acta
  end

  def edit
  	@tacjuramentados = TacJuramentado.find(params[:id])
    @tinsedes = TinSede.all
    @taccargos = TacCargo.all
    @taccompetencias = TacCompetencia.all
    @tacactas = TacActa.numero_acta	
  end

  def update
    @tacjuramentados = TacJuramentado.find(params[:id])
    if @tacjuramentados.update(juramentados_parametros_edit)
      redirect_to action: 'show', id: @tacjuramentados.id
    else
      render 'edit'
    end	
  end

  def destroy
    @tacjuramentados = TacJuramentado.find(params[:id])
    @tacjuramentados.destroy
    redirect_to juramentado_path
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

  private
    def juramentados_parametros
      params.require(:acta).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                   :segundo_apellido, :cedula, :cargo, :resolucion, :competencia,:tac_acta_id, :fecha_resolucion,:tac_unidades_id, :tac_extensiones_sedes_id)
       end

    def juramentados_parametros_edit
      params.require(:tac_juramentado).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                              :segundo_apellido, :cedula, :cargo, :sede, :resolucion, :competencia,:tac_acta_id, :fecha_resolucion)
    end

    def cedulados
      params.require(:cedula)
    end

    def tac_unidade_id
      params.require(:unidad)
    end


end
