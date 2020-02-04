class Constant
	def self.zimbra_config
    	YAML.load_file("#{Rails.root}/config/zimbra.yml")[Rails.env]
  	end

end