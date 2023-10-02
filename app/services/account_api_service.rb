require 'net/http'
require 'json'

class AccountApiService
    API_URL = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes'.freeze

    def self.check_balance(origin_account, value)

      uri = URI(API_URL)
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
       #data = JSON.parse(response.body)
        data = {
          balance: 100.50
        }

        balance = data['balance']

        if balance >= value
          return true 
        else
          return false
        end

      else
        return 'falha ao acessar api de conta'
      end
    end

end 