require 'date'
require 'time'
class Transference < ApplicationRecord
  def self.verify_errors_fields(input_transference:hash)
    errors = []
    if input_transference["value"] == nil
      errors.append('Valor da transferência faltando')
    end
    if input_transference["origin_account"] == nil
      errors.append('Dados de conta de origem da transferencia faltando')
    end
    if input_transference["target_account_or_pix_key"] == nil
      if input_transference["transference_type"] == 1
        return 'Chave pix da conta recebedora faltando'
      elsif input_transference["transference_type"] == 2 or input_transference["transference_type"] == 3
        return 'Dados de conta de recebimento faltando'
        end
    end
    if errors.empty?
      return nil
    end
  end
  # @param [Integer] input_transference, the transference data
  # @return [String]
  def self.create_PIX_transference_from_hash(input_transference:hash)
    @db_transaction_version = input_transference.clone
    missing_info_errors = self.verify_errors_fields(input_transference: input_transference)
    message = ''
    if missing_info_errors != nil
      return missing_info_errors
    else
      if self.transaction_is_for_now(input_transference:input_transference)
        @db_transaction_version["status"] = 0
        MiddleEndCommunicationService.send_value_to_target_account(input_transference:input_transference)
        message =  'Transferência por PIX enviada com sucesso'
      else
        @db_transaction_version["status"] = 1
        message = 'Transferência por PIX agendada com sucesso'
      end
      begin
        @transference = Transference.new(@db_transaction_version)
        @transference.save
      rescue
        message = 'Ocorreu um erro no salvamento do dado'
      end
      return message
    end
  end

  def self.transaction_is_for_now(input_transference:hash)
    if input_transference["selected_date"] == nil
      return true
    elsif Date.parse(input_transference["selected_date"]).iso8601 == Date.today.iso8601 and Time.now.hour.to_i >= input_transference["hour"]
      return true
    else
      return false
    end
  end
    def self.is_business_day(date)
      if Date.parse(date).wday == 0 or Date.parse(date).wday == 7
        return false
      else
        return true
      end
    end

  def get_scheduled_transferences
    self.where()
  end
end
