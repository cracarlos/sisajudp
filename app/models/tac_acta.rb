class TacActa < ApplicationRecord
  belongs_to :tac_firmante
  has_many :tac_juramentados
  
  def self.acta_abiertas
	select('numero_acta,sede,nombre_completo, tac_actas.id').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_firmante).
	  where(:estatus => "TRUE")
  end

  def self.acta_cerradas
	select('numero_acta,sede,nombre_completo, tac_actas.id').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_firmante).
	  where(:estatus => "FALSE")
  end

  def self.generar(generar)
	select('tac_actas.id,tac_actas.sede,numero_acta, tac_firmante_id,tac_juramentados.primer_nombre,tac_juramentados.segundo_nombre,tac_juramentados.primer_apellido,
		    tac_juramentados.segundo_apellido,cedula,tac_juramentados.cargo,resolucion,competencia,nombre_completo,tac_firmantes.cargo').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_juramentados, :tac_firmante).
	  where(id: generar)
  end
# 'INNER JOIN tac_juramentados ON tac_actas.id = tac_juramentados.tac_acta_id'
end
