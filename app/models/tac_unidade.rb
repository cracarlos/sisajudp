class TacUnidade < ApplicationRecord
	has_many :tac_extensiones_sede
	belongs_to :tac_juramentados

	def self.extensiones_sedes(id)

	  	#select('/'NUMCEDULA'/, /"PRIMERNOMBRE/", /"SEGUNDONOMBRE/", /"PRIMERAPELLIDO/","SEGUNDOAPELLIDO"').
	  	select('tac_extensiones_sedes.id, tac_extensiones_sedes.coordinaciones_extensiones, coordinaciones_regionales').
		joins(:tac_extensiones_sede).
	 	where(id: id)
		#rest[0]
  	
  	end

end