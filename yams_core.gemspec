$:.push File.expand_path("lib", __dir__)

# Maintain your s.add_dependency's version:
require "yams_core/version"

# Describe your s.add_dependency and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "yams_core"
  s.version     = YamsCore::VERSION
  s.authors     = ["Tom Statter"]
  s.email       = ["tomstatter@autotelik.co.uk"]
  s.homepage    = "http://www.yams.fm"
  s.summary     = "Open Source Rails engine for sharing music."
  s.description = "Yet Another Music Service - Open Source Rails engine for creating music sharing sites, band pages or record shops."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "spec/factories/**/*", 'docker-compose.yml', 'MIT-LICENSE', "Rakefile", "README.md"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_dependency 'coffee-rails', '~> 4.2'
  s.add_dependency 'jbuilder', '~> 2.5'

  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'turbolinks', '~> 5'
  s.add_dependency 'uglifier', '>= 1.3.0'

  # YAMS
  #
  s.add_dependency 'active_storage_validations'
  s.add_dependency 'acts-as-taggable-on'            # https://github.com/mbleigh/acts-as-taggable-on
  s.add_dependency 'administrate'

  s.add_dependency 'bourbon'

  s.add_dependency 'devise'
  s.add_dependency 'devise-jwt'
  s.add_dependency 'devise_invitable'                # An invitation strategy for devise

  s.add_dependency 'elasticsearch-model', '~> 5.1.0' # major release should match the ES major release in docker compose
  s.add_dependency 'elasticsearch-rails', '~> 5.1.0'

  s.add_dependency 'image_processing', '~> 1.7'

  s.add_dependency 'kaminari'

  s.add_dependency 'loofah', ">= 2.2.3"

  s.add_dependency "nokogiri", ">= 1.8.5"

  s.add_dependency 'pg', '~> 0.18'
  s.add_dependency 'pundit'

  s.add_dependency "rails_event_store"
  s.add_dependency 'rails_sortable', '~> 1.2.1'
  s.add_dependency 'rubyzip', '~> 1.2.2'

  s.add_dependency 'select2-rails'
  s.add_dependency 'searchkick'
  s.add_dependency 'sidekiq'

  s.add_dependency 'tzinfo-data'

  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'

  s.add_development_dependency 'i18n-tasks', '~> 0.9.24'
  s.add_development_dependency 'listen', '>= 3.0.5', '< 3.2'

  s.add_development_dependency 'rails_layout'
  s.add_development_dependency 'rubocop', '~> 0.57.2'
  s.add_development_dependency 'web-console', '>= 3.3.0'

  s.add_development_dependency "sqlite3", "~> 1.3.6"

end
