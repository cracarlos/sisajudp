class TacJuramentado  < ApplicationRecord
  belongs_to :tac_acta
  has_many :tac_unidade
  has_many :tac_extensiones_sede
  has_many :tac_materia
  has_many :tac_juramentado_materias, inverse_of: :tac_juramentado, dependent: :destroy 
  accepts_nested_attributes_for :tac_juramentado_materias, reject_if: :all_blank, allow_destroy: true

  def self.numero_acta
	select('* ,tac_juramentados.id').
  joins("INNER JOIN tac_actas ON tac_actas.id = tac_juramentados.tac_acta_id 
       INNER JOIN tac_unidades ON tac_unidades.id = tac_juramentados.tac_unidade_id
       LEFT JOIN tac_extensiones_sedes ON tac_extensiones_sedes.id = tac_juramentados.tac_extensiones_sedes_id
       INNER JOIN tac_cargos ON tac_cargos.id = tac_juramentados.tac_cargo_id
       ").
  where('tac_actas.estatus = true')
  end

  def self.acta_abiertas
	select('numero_acta').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_acta).
	  where(estatus: true)
  end

  def self.multi
  	select("*, tm.materia").
  	from("(SELECT *, unnest(tac_materia_id) as arreglo
        FROM tac_juramentados) tj").
  	joins("INNER JOIN tac_materias tm on tj.arreglo = tm.id")
  	
  end

  def self.multi2
  	select('* ,tac_juramentados.id').
	joins("INNER JOIN tac_actas ON tac_actas.id = tac_juramentados.tac_acta_id 
		   INNER JOIN tac_unidades ON tac_unidades.id = tac_juramentados.tac_unidade_id
		   LEFT JOIN tac_extensiones_sedes ON tac_extensiones_sedes.id = tac_juramentados.tac_extensiones_sedes_id
		   ").
	where('tac_actas.estatus = true')
  	
  end

  def self.multic3
  	select("*").
  	joins("INNER JOIN tac_materias tm on tac_juramentados.tac_materia_id = tm.id")
  	
  end

end
