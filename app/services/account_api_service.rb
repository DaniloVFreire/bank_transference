require 'net/http'
require 'json'

class AccountApiService
    API_URL = ENV['MIDDLE_END_BASE_URL'].freeze
    # Check with middle-end if the origin account have the value
    # return 0: no error, 1: not enough money the origin account, 2: server communication error
    def self.check_balance(origin_account, value)
      puts 'Checando se tem valor na conta'
      url = URI(API_URL)
      request = Net::HTTP::Get.new(url.to_s)
      response = Net::HTTP.start(url.host) {|http|
        http.request(request)
      }
      puts "---------------------------------------------------------------------------------------------------------------------------"
      puts response.to_s
      puts "---------------------------------------------------------------------------------------------------------------------------"
      if response.is_a?(Net::HTTPSuccess)
        body = JSON.parse(response.body)
        data = {
          "balance" => body["number"]
        }
        puts "Info from api"
        puts "balance: " + data["balance"].to_s
      else
        return 2
      end
      data = {
        "balance" => 100.50
      }
      balance = data["balance"].to_f
      puts "balance: " + balance.to_s
      

        if balance >= value
          return 0 
        else
          return 1
        end
    end
    def self.send_transference(input_transference:hash)
      puts input_transference.to_s
      puts 'enviou a transferencia'
      return 0
    end
end 