source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.0.0'

gem 'rails', '4.0.3'

gem "mongoid", "~> 4.0.0"
gem 'mongoid-versioning', github: 'simi/mongoid-versioning'
gem 'rails_admin', "~> 0.6.2"
gem "omniauth-google-apps", "~> 0.1.0"
gem 'ruby-openid-store-mongo'
gem 'turbolinks'
gem 'kaminari'
gem 'roo'
gem 'iconv', '~> 1.0.4'

# Flight API calls.
#gem "mongo", github: 'mongodb/mongo-ruby-driver'
#gem 'qpx', github: 'yawo/qpx'


# No need to specify a version for them
gem "annotate"
#gem 'thin'

# Logging
gem "lograge", "~> 0.2.2"

# Assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails', "~> 4.2.0"
gem 'mapbox-rails', '~> 1.6.1.1'
gem "geocoder"
gem "mongoid-paperclip", :require => "mongoid_paperclip"
gem 'smarter_csv'
gem "airbrake"

group :development, :test do
  gem 'debugger'
  gem "seed_dump"
  gem "binding_of_caller"
  gem "better_errors"
  gem 'coffee-rails-source-maps'
end

group :test do
  gem "factory_girl_rails"
  gem "shoulda"
  gem 'mocha'
  gem "nokogiri", '~> 1.6.1'
  gem "capybara"
  gem "database_cleaner", "~> 1.2.0"
  gem "tconsole"
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end