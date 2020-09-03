class TinSede < ApplicationRecord
    #Descomentar cuando este en la DP
    #establish_connection "intranet_development"
    #establish_connection "intranet_#{Rails.env}".to_sym
end
