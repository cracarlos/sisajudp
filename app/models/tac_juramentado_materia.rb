class TacJuramentadoMateria < ApplicationRecord
  belongs_to :tac_juramentado
  belongs_to :tac__materia
  belongs_to :tac_acta
end