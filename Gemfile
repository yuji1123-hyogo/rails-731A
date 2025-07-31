source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.8'

gem 'bootsnap', require: false
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'jbuilder'
gem 'puma', '~> 6.0'
gem 'rails', '7.1.5.1'
gem 'redis', '~> 4.0'
gem 'sassc-rails'
gem 'sqlite3', '~> 1.4'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'

# Windows環境用のタイムゾーンデータ
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# JWT認証用
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 6.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', require: false
end
