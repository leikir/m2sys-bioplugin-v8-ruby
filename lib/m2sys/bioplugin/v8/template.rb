module M2SYS
  module BioPlugin
    module V8

      class Template

        def initialize
          raise 'Cannot initialize abstract Template class'
        end

        def register(id:)
          Client.new.register(id: id, template: self)
        end

        def identify
          Client.new.identify(template: self)
        end

        def as_format
          raise NotImplementedError
        end

        def as_biometric_xml
          raise NotImplementedError
        end

      end

    end
  end
end
