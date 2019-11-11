class TacJuramentado  < ApplicationRecord
  belongs_to :tac_acta

  def self.numero_acta
	select('* ,tac_juramentados.id').
	joins(:tac_acta)
  end
end
