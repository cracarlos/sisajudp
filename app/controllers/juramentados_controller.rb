class JuramentadosController < ApplicationController
  before_action :authenticate_usuario!
  def new
    @tinsedes = TinSede.all
    @taccargos = TacCargo.all
    @taccompetencias = TacCompetencia.all
    @tacprejuramentados = TacPreJuramentado.all
    @tacactas = TacActa.all
  end

  def create

  	@tacprejuramentados = TacPreJuramentado.new(juramentados_parametros)
    puts '---------------------------', @tacprejuramentados.inspect
    if @tacprejuramentados.save
      puts '---------------------------', @tacprejuramentados.inspect
      puts '.......................', @tacprejuramentados.id, @tacprejuramentados.cedula
      redirect_to action: 'show', id: @tacprejuramentados.id
    else
      render 'new'
    end
  	
  end

  def show
    @tacprejuramentados = TacPreJuramentado.all
  end

  def edit
  	@tacprejuramentados = TacPreJuramentado.find(params[:id])
    @tinsedes = TinSede.all
    @taccargos = TacCargo.all
    @taccompetencias = TacCompetencia.all
    @tacactas = TacActa.all

  	
  end

  def update
    @tacprejuramentados = TacPreJuramentado.find(params[:id])
    #puts' !!!!!!!!!!!!', @tacprejuramentados.inspect

    if @tacprejuramentados.update(juramentados_parametros_edit)
      redirect_to action: 'show', id: @tacprejuramentados.id
    else
      render 'edit'
    end
  	
  end

  def destroy
    @tacprejuramentados = TacPreJuramentado.find(params[:id])
    @tacprejuramentados.destroy
 
    redirect_to juramentado_path
  end

  private
  def juramentados_parametros
         params.require(:acta).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                      :segundo_apellido, :cedula, :cargo, :sede, :resolucion, :competencia,:id_numero_acta)
       end

  def juramentados_parametros_edit
         params.require(:tac_pre_juramentado).permit(:primer_nombre, :segundo_nombre,:primer_apellido, 
                                      :segundo_apellido, :cedula, :cargo, :sede, :resolucion, :competencia,:id_numero_acta)
       end


end
