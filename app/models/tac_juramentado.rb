class TacJuramentado  < ApplicationRecord
  belongs_to :tac_acta
  has_many :tac_unidade
  has_many :tac_extensiones_sede

  def self.numero_acta
	select('* ,tac_juramentados.id').
	joins("INNER JOIN tac_actas ON tac_actas.id = tac_juramentados.tac_acta_id 
		   INNER JOIN tac_unidades ON tac_unidades.id = tac_juramentados.tac_unidades_id
		   INNER JOIN tac_extensiones_sedes ON tac_extensiones_sedes.id = tac_juramentados.tac_extensiones_sedes_id").
	where('tac_actas.estatus = true')
  end

  def self.acta_abiertas
	select('numero_acta').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_acta).
	  where(estatus: true)
  end

end
