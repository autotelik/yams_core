# frozen_string_literal: true

require_relative 'common/task_common'

module YamsCore

  module Docker

    class Dev < Thor
      include TaskCommon

      desc :up, 'Build development cluster : Sidekiq, DB, ELK'

      method_option :init, type: :boolean, default: false

      def up
        docker_up('sidekiq')

        if(options[:init])
          docker_exec(cmd: 'bundle exec rake db:create')
          docker_exec(cmd: 'bundle exec rake db:migrate')
          docker_exec(cmd: 'bundle exec rake db:seed')
        end
      end

    end

    class Prod < Thor
      include TaskCommon

      desc :up, 'Build cluster : Db, SideKiq, Redis, ELK containers'

      def up
        cli = "docker-compose -f docker-compose.yml up --no-recreate -d sidekiq"
        puts "Running": cli
        system cli
      end
    end

    %w{ Elasticsearch Kibana Redis Sidekiq }.each do |name|

      klass = Class.new(Thor) do
        include TaskCommon

        desc :up, "Start #{name} docker container"
        define_method(:up) {
          docker_up("#{name.downcase}")
        }
      end

      YamsCore.const_set name, klass
    end

  end

end
