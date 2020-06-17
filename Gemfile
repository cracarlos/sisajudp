source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Gestor de Bases de Datos PostgreSQL
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Crea usuarios
gem 'devise'
# FrameWork de CSS
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'

# DataTables
#gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#Generar PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'


# Formularios anidados
# Instalación >> https://github.com/nathanvda/cocoon 
# Ejemplos >> https://www.sitepoint.com/better-nested-attributes-in-rails-with-the-cocoon-gem/
gem 'cocoon'

# Iconos
#gem 'font-awesome-rails'

# Net::LDAP para Ruby (también llamado net-ldap) implementa el acceso del cliente para
# el Lightweight Directory Access Protocol (LDAP)
# Un protocolo estándar IETF para acceder a los servicios de directorio distribuidos.
# Net::LDAP está escrito completamente en Ruby sin dependencias externas.
# Es compatible con la mayoría de las características de cliente LDAP y un subconjunto de características de servidor también
gem 'net-ldap', '0.16.0'