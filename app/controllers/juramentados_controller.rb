class JuramentadosController < ApplicationController
  before_action :authenticate_usuario!

  def new
    @tinsedes = TinSede.all
    @taccargos = TacCargo.all
    @taccompetencias = TacCompetencia.all
    @tacjuramentados = TacJuramentado.all
    @tacactas = TacActa.all
  end

  def create
    @tacjuramentados = TacJuramentado.new(juramentados_parametros)
    if @tacjuramentados.save
      redirect_to action: 'show', id: @tacjuramentados.id
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
    @tacactas = TacActa.all 	
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

  private
    def juramentados_parametros
      params.require(:acta).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                   :segundo_apellido, :cedula, :cargo, :sede, :resolucion, :competencia,:tac_acta_id)
       end

    def juramentados_parametros_edit
      params.require(:tac_juramentado).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                              :segundo_apellido, :cedula, :cargo, :sede, :resolucion, :competencia,:tac_acta_id)
    end


end
