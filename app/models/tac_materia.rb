class TacMateria < ApplicationRecord
	belongs_to :tac_competencia
	belongs_to :tac_juramentado
end