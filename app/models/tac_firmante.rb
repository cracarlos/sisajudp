class TacFirmante < ApplicationRecord
  has_many :tac_actas

  def self.probando
	select('nombre_completo').
	joins("INNER JOIN tac_firmantes ON tac_firmantes.id = tac_acta.id_firmante").
	where('tac_acta.id_firmante = 3')
  end

end
