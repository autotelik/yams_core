# frozen_string_literal: true

module YamsCore
  module Services
    extend ActiveSupport::Concern
    class_methods do
      def call(*args)
        new(*args).call
      end
    end

    def uri?(string)
      uri = URI.parse(string)
      %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end

  end
end
