class TacActa < ApplicationRecord
  belongs_to :tac_firmante
  has_many :tac_juramentados
  
  def self.acta_abiertas
	select('numero_acta,sede,nombre_completo, tac_actas.id').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_firmante).
	  where(estatus: true)
  end

  def self.acta_cerradas
	select('numero_acta,sede,nombre_completo, tac_actas.id').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_firmante).
	  where(:estatus => "FALSE")
  end

  def self.generar(generar)
	select('tac_actas.id,tac_actas.sede,numero_acta, tac_firmante_id,
		    tac_juramentados.primer_nombre,tac_juramentados.segundo_nombre,tac_juramentados.primer_apellido,
		    tac_juramentados.segundo_apellido,cedula,tac_juramentados.cargo AS cargo_j,
		    tac_juramentados.resolucion,competencia,tac_firmantes.nombre_completo,tac_firmantes.cargo AS cargo_f,
		    tac_firmantes.nombramiento,
		    tac_firmantes.titulo'
		    ).
	  joins(:tac_juramentados, :tac_firmante).
	  where(id: generar)
  end
end
