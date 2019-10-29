class TacActa < ApplicationRecord
	has_many :TacFirmante

	def self.para_probar
		select('id,numero_acta,sede,id_firmante').
		where(sede: 'AVENIDA PERIMETRAL, AL LADO DE LA C.V.G., EDF. CIRCUITO JUDICIAL DEL ESTADO AMAZONAS, PLANTA BAJA'
			)
	end

	def firmante_nombre

		
	end
end
