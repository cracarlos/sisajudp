class TacActa < ApplicationRecord
  belongs_to :tac_firmante
  has_many :tac_pre_juramentados
  
  def self.firmante_nombre
	select('numero_acta,sede,nombre_completo, tac_actas.id').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_firmante)
  end

  def self.generar(generar)
	select('tac_actas.sede,numero_acta, tac_firmante_id,primer_nombre,segundo_nombre,primer_apellido,
		    segundo_apellido,cedula,cargo,resolucion,competencia').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins('INNER JOIN tac_pre_juramentados ON tac_actas.numero_acta = tac_pre_juramentados.id_numero_acta').
	  where(numero_acta: generar)
  end

end
