# frozen_string_literal: true

# Under the hood we use - https://github.com/huacnlee/rails-settings-cached
module YamsCore
  class Setting < ::YamsCore::SettingExtension

    # ENV helper to check if a .env variable exists AND is set to true
    #
    def self.env?( env_var )
      ENV[env_var].to_s.downcase == 'true'
    end

    # Define your fields

    # types: :integer, :string, :boolean, :array, :hash
    #
    # Options:
    #
    #   readonly: true | false - If false, Not editable in UI
    #   default:
    #   docs:
    #
    # rubocop:disable Metrics/LineLength
    #
    field :default_recomended_price, type: :hash, default: {download: 1000}, docs: 'Map of default prices per available mode'

    field :default_ccy, type: :string, default: 'satoshi', docs: 'satoshi is a one hundred millionth of a single bitcoin (0.00000001 BTC)'

    # rubocop:enable Metrics/LineLength
    #
    def self.jade_tile_requests?
      Setting.tile_request_strategy == 'jade' || Setting.tile_request_strategy == :jade
    end

  end
end
