source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'attr_encrypted'
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
gem 'redis-namespace'
gem 'sidekiq', '<7'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uuidtools' # For unique IDs (used by the epp gem)
gem 'i18n-tasks', '~> 1.0.12'
gem 'pagy', '~> 6.0'
gem 'country_select'
gem 'heroicon'
gem "view_component"

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
  gem 'brakeman', require: false
  gem 'bundle-audit', require: false
end

group :development do
  gem 'i18n-debug'
  gem 'rubocop'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webdrivers'
  gem 'shoulda-matchers'
end
