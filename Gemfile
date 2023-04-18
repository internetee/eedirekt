source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'cancancan'
gem 'cssbundling-rails'
gem 'epp', github: 'internetee/epp', branch: :master
gem 'epp-xml', '1.2.0', github: 'internetee/epp-xml', branch: :master
gem 'faraday'
gem 'figaro'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'omniauth', '>=2.0.0'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-tara', github: 'internetee/omniauth-tara'
gem 'pg', '~> 1.1'
gem 'propshaft'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'
gem 'redis', '~> 4.0'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uuidtools' # For unique IDs (used by the epp gem)

# gem "kredis"
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem 'annotate'
  gem 'database_cleaner'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'i18n-debug'
  gem 'rubocop'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
