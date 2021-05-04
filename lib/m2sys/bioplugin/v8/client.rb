module M2SYS
  module BioPlugin
    module V8
      class Client
        def initialize(api_host: M2SYS::BioPlugin::V8.api_host,
                       engine_name: M2SYS::BioPlugin::V8.engine_name,
                       client_key: M2SYS::BioPlugin::V8.client_key,
                       client_api_key: M2SYS::BioPlugin::V8.client_api_key)
          @api_host = api_host
          @engine_name = engine_name
          @client_key = client_key
          @client_api_key = client_api_key
        end

        def register(id:, template:)
          body = {
            registrationID: id,
            clientKey: @client_key,
            images: template.as_biometric
          }

          response = api_request(:Register, body)

          if response['OperationStatus'] == 'SUCCESS'
            if response['OperationResult'] == 'SUCCESS'
              RegisterSuccess.new(body: response)
            else
              raise RegisterMatchFoundError.new(body: response, match_id: response['InstanceID'])
            end
          else
            raise RegisterError.new(body: response)
          end
        end

        def identify(template:)
          body = {
            clientKey: @client_key,
            images: template.as_biometric
          }
          response = api_request(:Identify, body)

          if response['OperationStatus'] == 'SUCCESS'
            if response['OperationResult'] == 'MATCH_FOUND' && response['BestResult']['Score'].to_i.positive?
              IdentifySuccess.new(
                body: response,
                match_id: response['BestResult']['ID'],
                score: response['BestResult']['Score'].to_i
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
            clientKey: @client_key,
            RegistrationID: id
          }
          response = api_request(:DeleteID, body)

          if response['OperationStatus'] == 'SUCCESS'
            if response['OperationResult'] == 'DS'
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
            clientKey: @client_key,
            RegistrationID: id,
            images: template.as_biometric
          }
          response = api_request(:Verify, body)
          
          if response['OperationStatus'] == 'SUCCESS'
            if response['OperationResult'] == 'VS'
              VerifySuccess.new(body: response)
            else
              raise VerifyIdNotExistError.new(body: response)
            end
          else
            raise VerifyError.new(body: response)
          end
        end

        private

        def get_authorization_token
          @api_host = 'https://dev-bioplugin.cloudabis.com/api/Biometrics'
          url = URI("#{@api_host.gsub('Biometrics', 'Authorizations')}/Token")
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request['Content-Type'] = ['application/json']
          request['Accept'] = 'application/json'
          request.body = JSON.generate({
            clientAPIKey: @client_api_key,
            clientKey: @client_key
          })

          response = http.request(request)

          response_body = JSON.parse(response.read_body)

          response_body['ResponseData']['AccessToken'] if response_body['Status'] == 'Success'
        end

        def api_request(action, body)
          bearer_token = get_authorization_token

          url = URI("#{@api_host}/#{action}")          
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(url)
          request['Content-Type'] = ['application/json']
          request['Accept'] = 'application/json'
          request['Authorization'] = "Bearer #{bearer_token}"
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
