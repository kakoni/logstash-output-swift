# encoding: utf-8
require "stud/temporary"
require "socket"
require "fileutils"

module LogStash
  module Outputs
    class Swift
      class WriteContainerPermissionValidator
        attr_reader :logger

        def initialize(logger)
          @logger = logger
        end

        def valid?(container_resource)
          begin
            upload_test_file(container_resource)
            true
          rescue StandardError => e
            logger.error("Error validating bucket write permissions!",
              :message => e.message,
              :class => e.class.name,
              :backtrace => e.backtrace
              )
            false
          end
        end

        private
        def upload_test_file(container_resource)
          generated_at = Time.now

          key = "logstash-programmatic-access-test-object-#{generated_at}"
          content = "Logstash permission check on #{generated_at}, by #{Socket.gethostname}"

          begin
            obj = container_resource.files.create(key: key, body: content)

            begin
              obj.destroy
            rescue
              # Try to remove the files on the remote bucket,
              # but don't raise any errors if that doesn't work.
              # since we only really need `putobject`.
            end
          end
        end
      end
    end
  end
end
