class DatoPersonaV < ApplicationRecord
	# Descomentar cuando esté en la DP
	#self.table_name  = "datos_personas_v"
	#establish_connection "cedulados_#{Rails.env}".to_sym

  def self.cedulados(cedula)
  	#select('/'NUMCEDULA'/, /"PRIMERNOMBRE/", /"SEGUNDONOMBRE/", /"PRIMERAPELLIDO/","SEGUNDOAPELLIDO"').
  	rest = select(:NUMCEDULA, :PRIMERNOMBRE, :SEGUNDONOMBRE, :PRIMERAPELLIDO, :SEGUNDOAPELLIDO).
	where(NUMCEDULA: cedula)
	rest[0]
  	
  end
end