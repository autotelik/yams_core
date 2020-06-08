# frozen_string_literal: true

module YamsCore
  class Artist < User

    searchkick callbacks: :queue

    def search_data
      {
          name: :name
      }
    end

    def after_save_hook

      begin
        Searchkick::ProcessQueueJob.perform_later(class_name: "YamsCore::Track")
      rescue Redis::CannotConnectError => x
        Rails.logger.error("Redis DOWN - Elastic search update failed #{x.message}")
      rescue  => x
        Rails.logger.error("UNHANDLED - Elastic search update failed #{x.message}")
      end

    end

  end
end