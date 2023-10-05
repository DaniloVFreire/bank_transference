require 'net/http'
require 'json'

class AccountApiService
    API_URL = ENV['MIDDLE_END_BASE_URL'].freeze
    # Check with middle-end if the origin account have the value
    # return 0: no error, 1: not enough money the origin account, 2: server communication error
    def self.check_balance(origin_account, value)
      puts 'Checando se tem valor na conta'
      begin
        uri = URI(API_URL)
        request = Net::HTTP::Get.new(uri.to_s)
        response = Net::HTTP.start(uri.host) {|http|
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
      return 1
    end
    def self.remove_value_from_sender_account(input_transference:hash)
      begin
        uri = URI(API_URL)
        request = Net::HTTP::Post.new(uri.to_s)
        request['Content-Type'] = 'application/json'
        request.body = { origin_account: input_transference["origin_account"],
                         value: input_transference["value"].to_f }.to_json
        response = Net::HTTP.start(uri.host,uri.port) {|http|
          http.request(request)
        }
        if response.is_a?(Net::HTTPSuccess)
          return 0
        else
          return 1
        end
      rescue
        puts 'Removeu o valor da conta emissora'
        return 1
      end
      return 0
    end
    def self.send_value_to_target_account(input_transference:hash)
      begin
        uri = URI(API_URL)
        request = Net::HTTP::Post.new(uri.to_s)
        request['Content-Type'] = 'application/json'
        request.body = { target_account_or_pix_key: input_transference["target_account_or_pix_key"],
                         value: input_transference["value"].to_f }.to_json
        response = Net::HTTP.start(uri.host,uri.port) {|http|
          http.request(request)
        }
        if response.is_a?(Net::HTTPSuccess)
          return 0
        else
          return 1
        end
      rescue
        puts 'Enviou o valor para conta recebedoura'
        return 1
      end
      return 0
    end
end 