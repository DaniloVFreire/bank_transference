require 'date'
class Transference < ApplicationRecord
  def self.verify_errors_fields(input_transference:hash)
    errors = []
    if input_transference["value"] == nil
      errors.append('Valor da transferência faltando')
    end
    if input_transference["origin_account"] == nil
      return 'Conta de origem da transferência faltando'
    end
    if input_transference["target_account_or_pix_key"] == nil
      return 'Chave pix da conta recebedora faltando'
    end
    puts Date.today.iso8601.to_s

    if errors.empty?
      return nil
    end
  end
  def self.create_transference_from_hash(input_transference:hash)
    @db_transaction_version = input_transference.clone
    errors = self.verify_errors_fields(input_transference: input_transference)
    if errors != nil
      return errors
    else
      if self.transaction_is_for_now(input_transference:input_transference)
        @db_transaction_version["status"] = 0
        AccountApiService.send_transference(input_transference:input_transference)
        return 'Transferência por PIX enviada com sucesso'
      else
        @db_transaction_version["status"] = 1
        return 'Transferência por PIX agendada com sucesso'
      end

      @transference = Transference.new(@db_transaction_version)
      @transference.save
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

  def get_scheduled_transferences
    self.where()
  end
end
