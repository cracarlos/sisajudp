class TacActa < ApplicationRecord
  belongs_to :tac_firmante
  has_many :tac_juramentados
  
  def self.acta_abiertas
	select('numero_acta,sede,nombre_completo, tac_actas.id').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_firmante).
	  where(estatus: true)
  end

  def self.acta_cerradas
	select('numero_acta,sede,nombre_completo, tac_actas.id, titulo').
	  #joins('INNER JOIN tac_firmantes ON tac_actas.id_firmante = tac_firmantes.id')
	  joins(:tac_firmante).
	  where(:estatus => "FALSE")
  end

  def self.generar(generar)
	select("tac_actas.id,tac_actas.sede,numero_acta, tac_firmante_id, para,
		    tac_juramentados.primer_nombre,tac_juramentados.segundo_nombre,tac_juramentados.primer_apellido,
		    tac_juramentados.segundo_apellido,cedula,tac_juramentados.cargo AS cargo_j,
		    tac_juramentados.resolucion,
		    TO_CHAR(tac_juramentados.fecha_resolucion, 'dd/mm/yyyy') AS fecha_resolucion,
		    competencia, tac_firmantes.nombre_completo, tac_firmantes.cargo AS cargo_f,
		    tac_firmantes.nombramiento,
		    tac_firmantes.titulo,tac_firmantes.texto,tac_materias.materia, tac_unidades.coordinaciones_regionales,
		    tac_extensiones_sedes.coordinaciones_extensiones"
		    ).
	  joins(" 
		   INNER JOIN tac_juramentados ON tac_juramentados.tac_acta_id = tac_actas.id
		   INNER JOIN tac_unidades ON tac_unidades.id = tac_juramentados.tac_unidade_id
		   LEFT JOIN tac_extensiones_sedes ON tac_extensiones_sedes.id = tac_juramentados.tac_extensiones_sedes_id
		   INNER JOIN tac_competencias ON tac_competencias.id = tac_juramentados.tac_competencia_id
		   INNER JOIN tac_materias ON tac_materias.id = tac_juramentados.tac_materia_id
		   INNER JOIN tac_firmantes ON tac_firmantes.id = tac_actas.tac_firmante_id").
	  where(id: generar)
	  #joins(:tac_juramentados, :tac_firmante, :tac_competencia)
  end

  def self.anio_en_letras(anio)
  	a = find_by_sql("SELECT monto_escrito(#{anio}) AS anio_letras")
  	a[0].anio_letras
  end

  def self.dia_en_letras(dia)
  	b = find_by_sql("SELECT monto_escrito(#{dia}) AS dia_letras")
  	b[0].dia_en_letras
  end

  def self.numero_acta
	select('id,numero_acta').where(estatus: true)
  end
end
