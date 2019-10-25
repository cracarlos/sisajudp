class TacPreJuramentado < ApplicationRecord
	def self.generar_acta()
		joins(:tac_actas).where(id_numero_acta: 2)
		
	end
    
end