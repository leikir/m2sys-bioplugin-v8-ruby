module M2SYS
  module BioPlugin
    module V8

      class Success
        def initialize(body:)
          @body = body
        end

        def body
          @body
        end
      end

      class Error < StandardError
        def initialize(body:)
          @body = body
        end

        def body
          @body
        end
      end

      # REGISTER

      class RegisterSuccess < Success; end

      class RegisterError < Error
        def message
          'Register request error'
        end
      end

      class RegisterMatchFoundError < Error
        def initialize(body:, match_id:)
          super(body: body)
          @match_id = match_id
        end

        def match_id
          @match_id
        end

        def message
          "Data already known as \"#{@match_id}\""
        end
      end

      # IDENTIFY

      class IdentifySuccess < Success
        def initialize(body:, match_id:, score:)
          super(body: body)
          @match_id = match_id
          @score = score
        end

        def match_id
          @match_id
        end

        def score
          @score
        end
      end

      class IdentifyNoMatchError < Error
        def message
          'No match found'
        end
      end

      class IdentifyError < Error
        def message
          'Identify request error'
        end
      end

      # DELETE

      class DeleteSuccess < Success; end

      class DeleteError < Error
        def message
          'Delete request error'
        end
      end

      class DeleteNotFoundError < Error
        def message
          'Record not found'
        end
      end

    end
  end
end
