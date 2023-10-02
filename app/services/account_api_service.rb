require 'net/http'
require 'json'

class AccountApiService
    API_URL = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes'.freeze

    def self.check_balance(origin_account, value)
      url = URI(API_URL)
      request = Net::HTTP::Get.new(url.to_s)
      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(request)
      }

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
      else
        return 'falha ao acessar api de conta'
        data = {
          balance: 100.50
        }
      end
      balance = data['balance'].to_f
      puts "balance: " + balance.to_s
      

        if balance >= value
          return true 
        else
          return false
        end
    end
end 