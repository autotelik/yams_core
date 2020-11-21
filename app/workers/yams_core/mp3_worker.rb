module YamsCore
  class Mp3Worker
    include Sidekiq::Worker

    def perform(track_id)
      track = YamsCore::Track.find(track_id)

      logger.info "Process #{track.id} MP3 properties"

      # TODO - active storage come along way - this needs refactoring
      #track.update(length: YamsCore::Mp3PropertiesService.length(track.audio)) unless track.length?
    end

  end
end
