class TinSede < ApplicationRecord
    #establish_connection "intranet_development"
    establish_connection "intranet_#{Rails.env}".to_sym
end
