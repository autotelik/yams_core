# frozen_string_literal: true

require "id3tag"

module YamsCore

  class Mp3PropertiesService

    include YamsCore::Services


    attr_reader :blob, :storage, :tags, :tmp_file

    def initialize(track)
      @storage = track.audio
     # @blob = storage.download

      storage.open do |temp_file|
        # if needed can access MP3 tags

        #@tags = ID3Tag.read(temp_file)
        #puts "TAGS:"
        #pp tags.inspect
      
        track.length = YamsCore::AudioService.get_duration_secs(temp_file.path)
        track.save!


        temp_file.close
        temp_file.unlink 
      end

    end

  end
end