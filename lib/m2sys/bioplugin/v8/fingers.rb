module M2SYS
  module BioPlugin
    module V8

      class Fingers < Template

        DATA_TYPE_IMAGE = :IMAGE
        DATA_TYPES = [
          DATA_TYPE_IMAGE
        ].freeze

        def initialize(data_type:, fingers:)
          raise "Unknown data type #{data_type}" unless DATA_TYPES.include?(data_type)
          @data_type = data_type

          fingers.each do |finger|
            raise 'Fingers template can only contain Finger instances' unless finger.is_a?(Finger)
          end
          @fingers = fingers
        end

        def as_format
          @data_type
        end

        def as_biometric_xml
          [
            '<Fingers>',
            @fingers.map do |finger|
              "<Finger POS='#{finger.pos}' Format='#{@data_type}'>#{finger.data}</Finger>"
            end,
            '</Fingers>'
          ].join
        end

      end

    end
  end
end
