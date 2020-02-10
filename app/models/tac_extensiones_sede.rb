class TacExtensionesSede < ApplicationRecord
	belongs_to :tac_unidade

	def self.extensiones_sedes( tac_unidade_id)
	  	rest = select(:id, :coordinaciones_extensiones).
		joins(:tac_unidade).
	 	where(tac_unidade_id: tac_unidade_id )
		#rest[0]
  	end
end