require "webpacker/helper"

module YamsCore
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      YamsCore.webpacker
    end
  end
end