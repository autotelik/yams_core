require "rails"

require 'coffee-rails'
require 'jbuilder'

require 'sass-rails'
require 'turbolinks'
require 'uglifier'

require 'active_storage_validations'
require 'acts-as-taggable-on'
require 'administrate'
require 'autoprefixer-rails'

require 'bourbon'

#require 'datashift_audio_engine'

require 'devise'
#require 'devise-jwt'
require 'devise_invitable'                # An invitation strategy for devise

require 'elasticsearch'
#require 'elasticsearch-rails'

require 'image_processing'

require 'kaminari'

require 'loofah'

require 'nokogiri'

require 'pg'
require 'pundit'

require "rails_event_store"
require 'rails_sortable'

#require 'rubyzip'

require 'select2-rails'
require 'searchkick'
require 'sidekiq'

module YamsCore
  class Engine < ::Rails::Engine
    isolate_namespace YamsCore

    # Add a load path for this specific Engine
    config.autoload_paths << File.expand_path("../app/workers/yams_core", __FILE__)

    def self.load_thor_tasks
      base = File.join(YamsCore.library_path, 'tasks')

      Dir["#{base}/*.thor"].each do |f|
        next unless File.file?(f)
        Thor::Util.load_thorfile(f)
      end
    end

  end
end
