source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.0.0'

gem 'rails', '4.0.3'

gem "mongoid", "~> 4.0.0.beta1"
gem 'mongoid-versioning', github: 'simi/mongoid-versioning'
gem 'rails_admin', "~> 0.6.2"
gem "omniauth-google-apps", "~> 0.1.0"
gem 'ruby-openid-store-mongo'
gem 'turbolinks'
gem 'kaminari'
gem 'roo'
gem 'iconv', '~> 1.0.4'

# No need to specify a version for them
gem "annotate"
gem 'thin'

# Logging
gem "lograge", "~> 0.2.2"

# Assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails', "~> 4.2.0"

group :development, :test do
  gem 'debugger'
  gem "seed_dump"
  gem "binding_of_caller"
  gem "better_errors"
end

group :test do
  gem "shoulda", :require => false
  gem 'mocha', :require => false
  gem "nokogiri"
  gem "capybara"
  gem "tconsole"
  gem "database_cleaner", "~> 1.2.0"
end