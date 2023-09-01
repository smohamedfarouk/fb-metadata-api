source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'fb-jwt-auth', '~> 0.10.0'
gem 'kaminari'
gem 'metadata_presenter', '~> 3.2.10'
gem 'pg', '>= 0.18', '< 2.0'
gem 'prometheus-client', '~> 2.1.0'
gem 'puma', '~> 6.3'
gem 'rails', '~> 7.0.6'
gem 'sentry-rails', '~> 5.10.0'
gem 'sentry-ruby', '~> 5.10.0'
gem 'tzinfo-data'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'httparty'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'timecop'
end

group :development do
  gem 'brakeman'
  gem 'rubocop', '~> 1.55.0'
  gem 'rubocop-govuk'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end
