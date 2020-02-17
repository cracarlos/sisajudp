class TacCompetencia < ApplicationRecord
	has_many :tac_materia

	def self.competencia_materia
		select("tac_materias.materia").
		joins(:tac_materia).
		where("tac_competencias.id = 2")
		
	end
	def self.asd(id)
		select("materia").
		joins("INNER JOIN tac_materias ON tac_competencias.id = tac_materias.tac_competencia_id").
		where("tac_competencias.id = #{id}")
	end
end