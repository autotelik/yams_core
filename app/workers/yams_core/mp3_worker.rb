module YamsCore
  class Mp3Worker
    include Sidekiq::Worker

    def perform(track_id)
      track = YamsCore::Track.find(track_id)

      logger.info "Process #{track.id} MP3 properties"

      service = YamsCore::Mp3PropertiesService.new(track)
    end

  end
end
