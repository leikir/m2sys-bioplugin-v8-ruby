module M2SYS
  module BioPlugin
    module V8

      class Finger

        def initialize(pos:, data:)
          @pos = pos
          @data = data
        end

        def pos
          @pos
        end

        def data
          @data
        end

      end

    end
  end
end
