# frozen_string_literal: true


module YamsCore

  # For DropBox links the query string determines whether the raw file is downloaded or the preview HTML page (?dl=0)
  # so to get the raw audio file ensure ?dl=1
  #
  class AttachAudioService

    include YamsCore::Services

    attr_reader :receiver, :path

    def initialize(receiver, path)
      @receiver = receiver
      @path = path
    end

    def call

      if(uri?(path))
        base_uri = URI(path).path # strips qs etc

        # TODO How can I get content type from download  ?
        #   For Linux ...  `file --mime -b #{download.path}` => "text/html; charset=us-ascii\n"

        # This one uses the file ext but seems like could be dangerous, e.g upload JS with a .wav extension ?
        #   MIME::Types.type_for(File.extname(base_uri)).first.content_type
        require 'open-uri'
        download = open(path)

        receiver.audio.attach(io: download, filename: File.split(base_uri).last, content_type: YamsCore::AudioService.valid_types)
      else
        receiver.audio.attach(io: File.open(path), filename:  File.split(path).last, content_type: YamsCore::AudioService.valid_types)
      end
    end

  end
end
