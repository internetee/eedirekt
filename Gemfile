source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'attr_encrypted'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'cancancan'
gem 'country_select'
gem 'cssbundling-rails'
gem 'epp', github: 'internetee/epp', branch: :master
gem 'epp-xml', '1.2.0', github: 'internetee/epp-xml', branch: :master
gem 'faraday'
gem 'figaro'
gem 'heroicon'
gem 'i18n-tasks', '~> 1.0.12'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'omniauth', '>=2.0.0'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-tara', github: 'internetee/omniauth-tara'
gem 'pagy', '~> 6.0'
gem 'pg', '~> 1.1'
gem 'phonelib'
gem 'propshaft'
gem 'puma', '>= 6.4.2'
gem 'rails', '~> 7.1.5', '>= 7.1.5.2'
gem 'redis', '~> 4.0'
gem 'redis-namespace'
gem 'sidekiq', '>=7'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uuidtools' # For unique IDs (used by the epp gem)
gem 'view_component'
gem 'aasm'

# gem "kredis"
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem 'annotate'
  gem 'brakeman', require: false
  gem 'bundle-audit', require: false
  gem 'database_cleaner', '>= 2.0.2'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock'
  gem 'ruby-lsp'
end

group :development do
  gem 'i18n-debug'
  gem 'rubocop'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webdrivers'
end
