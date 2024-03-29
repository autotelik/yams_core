# Require gems needed for initialisation

require 'byebug' unless Rails.env.production?

require 'active_storage_validations'
require 'acts-as-taggable-on'            # https://github.com/mbleigh/acts-as-taggable-on
require 'administrate'

require 'bourbon'

require 'devise'
require 'devise_invitable'                # An invitation strategy for devise

require 'elasticsearch'                   # major release should match the ES major release in docker compose
#require 'elasticsearch-rails'

require 'image_processing'

require "nokogiri"

require 'pagy'
require 'pundit'

#  N.B 1.3 and 1.4 breaks
#     ActiveSupport::MessageVerifier::InvalidSignature (ActiveSupport::MessageVerifier::InvalidSignature):

require 'rails_sortable'  # https://github.com/itmammoth/rails_sortable

require 'searchkick'
require 'sidekiq'

require 'yams_audio'

module YamsCore

  ROOT_PATH = Pathname.new(File.join(__dir__, ".."))

  class Engine < ::Rails::Engine
    isolate_namespace YamsCore


    def self.load_thor_tasks
      base = File.join(YamsCore.library_path, 'tasks')

      Dir["#{base}/*.thor"].each do |f|
        next unless File.file?(f)
        Thor::Util.load_thorfile(f)
      end
    end

    initializer "model_core.factories", :after => "factory_bot.set_factory_paths" do
      FactoryBot.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__) if defined?(FactoryBot)
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    config.to_prepare do
      ApplicationController.helper(YamsCore::FormHelper)
      ApplicationController.helper(YamsCore::BootstrapHelper)
    end

    config.generators do |g|
      g.test_framework :rspec
    end

  end
end
