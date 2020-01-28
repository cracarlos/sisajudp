class TacJuramentado  < ApplicationRecord
  belongs_to :tac_acta

  def self.numero_acta
	select('* ,tac_juramentados.id, tac_juramentados.sede').
	joins(:tac_acta).
	where('tac_actas.estatus = true')
  end

  def self.acta_abiertas
	select('numero_acta').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_acta).
	  where(estatus: true)
  end

end
