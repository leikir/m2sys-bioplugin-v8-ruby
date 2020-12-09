module M2SYS
  module BioPlugin
    module V8

      class Client

        def initialize(api_host: M2SYS::BioPlugin::V8.api_host,
                       engine_name: M2SYS::BioPlugin::V8.engine_name)
          @api_host = api_host
          @engine_name = engine_name
        end

        def register(id:, template:)
          body = {
            EngineName: @engine_name,
            RegistrationID: id,
            Format: template.as_format,
            BiometricXml: template.as_biometric_xml
          }
          response = api_request(:Register, body)

          xml = Nokogiri::XML(response)
          results = xml.css('Results result')

          if results.first
            if results.first['value'] == 'SUCCESS'
              RegisterSuccess.new(body: response)
            else
              raise RegisterMatchFoundError.new(body: response, match_id: results.first['value'])
            end
          else
            raise RegisterError.new(body: response)
          end
        end

        def identify(template:)
          body = {
            EngineName: @engine_name,
            Format: template.as_format,
            BiometricXml: template.as_biometric_xml
          }
          response = api_request(:Identify, body)

          # puts 'Identify response:', response

          xml = Nokogiri::XML(response)
          results = xml.css('Results result')

          if results.first
            if results.first['score'].to_i > 0
              IdentifySuccess.new(
                body: response,
                match_id: results.first['value'],
                score: results.first['score'].to_i
              )
            else
              raise IdentifyNoMatchError.new(body: response)
            end
          else
            raise IdentifyError.new(body: response)
          end
        end

        def delete(id:)
          body = {
            RegistrationID: id
          }
          response = api_request(:RemoveID, body)

          # puts 'DeleteID response:', response

          xml = Nokogiri::XML(response)
          results = xml.css('Results result')

          if results.first
            if results.first['value'] == 'DS'
              DeleteSuccess.new(body: response)
            else
              raise DeleteNotFoundError.new(body: response)
            end
          else
            raise DeleteError.new(body: response)
          end
        end

        def verify(id:, template:)
          body = {
            EngineName: @engine_name,
            RegistrationID: id,
            Format: template.as_format,
            BiometricXml: template.as_biometric_xml
          }
          response = api_request(:Verify, body)

          xml = Nokogiri::XML(response)
          results = xml.css('Results result')

          if results.first
            if results.first['value'] == 'VS'
              VerifySuccess.new(body: response)
            else
              raise VerifyIdNotExistError.new(body: response)
            end
          else
            raise VerifyError.new(body: response)
          end
        end

        private

        def api_request(action, body)
          url = URI("#{@api_host}/#{action}")
          http = Net::HTTP.new(url.host, url.port)
          request = Net::HTTP::Post.new(url)
          request['Content-Type'] = ['application/json']
          request['Accept'] = 'application/json'
          request.body = JSON.generate(body)

          # puts 'POST', request.body, 'to', url

          response = http.request(request)

          # puts '-> reponse:', response.read_body

          JSON.parse(response.read_body)
        end

      end

    end
  end
end
