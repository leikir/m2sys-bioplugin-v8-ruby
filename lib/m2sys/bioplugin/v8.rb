require 'uri'
require 'net/http'
require 'json'
require 'nokogiri'

require 'm2sys/bioplugin/v8/template'
require 'm2sys/bioplugin/v8/finger'
require 'm2sys/bioplugin/v8/fingers'
require 'm2sys/bioplugin/v8/response'
require 'm2sys/bioplugin/v8/client'

module M2SYS
  module BioPlugin
    module V8

      ENGINE_NAME_FINGERPRINT = 'FPFF02'

      class << self
        attr_accessor :api_host,
                      :engine_name,
                      :client_key,
                      :client_api_key

        def configure
          yield self
          true
        end
        alias_method :config, :configure
      end

    end
  end
end
