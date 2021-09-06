# frozen_string_literal: true

module YamsCore

  class AttachCoverService

    include YamsCore::Services

    attr_reader :receiver, :path

    def initialize(receiver, path)
      @receiver = receiver
      @path = path
    end

    def call

       puts "DEBUG Attach Cover to #{receiver.inspect}"

      if(uri?(path))

        base_uri = URI(path).path # strips qs etc

        require 'open-uri'
        download = open(path)

        filename = begin
                     File.split(base_uri).last
                   rescue => e
                     puts "Failed to parse URI #{base_uri}"
                     puts e
                   end

        receiver.cover = Cover.create!(owner: receiver).tap { |c| c.image.attach(io: download, filename: filename) }
      else
        receiver.cover = Cover.create!(owner: receiver).tap do |c|
          c.image.attach(io: File.open(path), filename: File.split(path).last)
        end
      end
    end

  end
end
