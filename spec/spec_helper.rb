# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require_relative "supports/helpers"
require "logstash/logging/logger"
require "fog/openstack"

LogStash::Logging::Logger::configure_logging("debug") if ENV["DEBUG"]

module Fog
  module Storage
    class OpenStack

      class Mock

        def put_object(container, object, data, options = {}, &block)
          response = Excon::Response.new
          response.status = 201
          response.body = ""
          response
        end

        def put_container(name, options = {})
          response = Excon::Response.new
          response.status = 201
          response.body = ""
          response
        end

        def get_container(container, options = {})
          response = Excon::Response.new
          response.status = 201
          response.body = []
          response
        end

        def get_containers(options = {})
          response = Excon::Response.new
          response.status = 201
          response.body = []
          response
        end
      end

    end
  end
end

Fog.mock!
