class TacActa < ApplicationRecord
  belongs_to :tac_firmante
  has_many :tac_juramentados
  
  def self.firmante_nombre
	select('numero_acta,sede,nombre_completo, tac_actas.id').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_firmante)
  end

  def self.generar(generar)
	select('tac_actas.id,tac_actas.sede,numero_acta, tac_firmante_id,primer_nombre,segundo_nombre,primer_apellido,
		    segundo_apellido,cedula,cargo,resolucion,competencia').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_juramentados).
	  where(id: generar)
  end
# 'INNER JOIN tac_juramentados ON tac_actas.id = tac_juramentados.tac_acta_id'
end
