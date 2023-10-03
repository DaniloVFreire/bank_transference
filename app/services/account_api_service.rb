require 'net/http'
require 'json'

class MiddleEndCommunicationService
    API_URL = ENV['MIDDLE_END_BASE_URL'].freeze
    # Check with middle-end if the origin account have the value
    # return 0: no error, 1: not enough money the origin account, 2: server communication error
    def self.check_balance(origin_account, value)
      puts 'Checando se tem valor na conta'
      begin
        url = URI(API_URL)
        request = Net::HTTP::Get.new(url.to_s)
        response = Net::HTTP.start(url.host) {|http|
          http.request(request)
        }
        if response.is_a?(Net::HTTPSuccess)
          body = JSON.parse(response.body)
          data = {
            "balance" => body["number"]
          }
        else
          return 2
        end
      rescue
        return 2
      end
      balance = data["balance"].to_f
      puts "balance"
      puts "balance: " + balance.to_s
        if balance >= value
          return 0 
        else
          return 1
        end
    end
    def self.remove_value_from_target_account(input_transference:hash)
      puts input_transference.to_s
      puts 'Removeu o valor da conta emissora'
      return 0
    end
    def self.send_value_to_target_account(input_transference:hash)
      puts input_transference.to_s
      puts 'Enviou o valor para a conta receptora'
      return 0
    end
end 