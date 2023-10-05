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
        begin
          MiddleEndCommunicationService.remove_value_from_sender_account(input_transference:input_transference)
        rescue
          return 'Transferência por PIX, não efetuada por problemas de conexão, tente novamente mais tarde'
        end

        begin
          MiddleEndCommunicationService.send_value_to_target_account(input_transference:input_transference)
        rescue
          return 'Transferência por PIX, não efetuada por problemas de conexão, tente novamente mais tarde'
        end


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

  def self.create_TED_transference_from_hash(input_transference:hash)
    @db_transaction_version = input_transference.clone
    missing_info_errors = self.verify_errors_fields(input_transference: input_transference)
    message = ''
    current_hour_in_integer = Time.now.strftime("%H").to_i
    if missing_info_errors != nil
      return missing_info_errors
    else
      if self.transaction_is_for_now(input_transference:input_transference)
        @db_transaction_version["status"] = 1
        if self.is_business_day(date:Date.today,hour: current_hour_in_integer + 1)
          @db_transaction_version["selected_date"] = Date.today
          @db_transaction_version["hour"] = self.get_closest_business_hour(current_hour_in_integer + 1)
          message =  'Transferência por TED realizada com sucesso, o valor será enviado em no mínimo uma hora'
        else
          @db_transaction_version["selected_date"] = self.get_closest_business_day(Date.today)
          @db_transaction_version["hour"] = self.get_closest_business_hour(current_hour_in_integer + 1)
          message = 'A transferência TED não pode ser efetuada para hoje, ela será efetuada no próximo dia util'
        end
      else
        @db_transaction_version["status"] = 1
        selected_hour = @db_transaction_version["hour"].to_i
        current_date = Date.today
        begin
          selected_date = Date.parse(@db_transaction_version["selected_date"])
        rescue
          return "Data informada com problema"
        end

        if selected_date < current_date
          return "#{selected_date} é antes do dia de hoje, escolha uma data válida."
        end
        if self.is_business_day(date:selected_date,hour: selected_hour + 1)
          @db_transaction_version["selected_date"] = selected_date
          @db_transaction_version["hour"] = self.get_closest_business_hour(selected_hour + 1)
          message =  'Transferência por TED agendada com sucesso, o valor será enviado em no mínimo uma hora'
        else
          @db_transaction_version["selected_date"] = self.get_closest_business_day(selected_date)
          @db_transaction_version["hour"] = self.get_closest_business_hour(selected_hour + 1)
          message = 'A transferência TED não pode ser efetuada para o dia selecionado, ela será efetuada no próximo dia util'
        end
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

  def self.create_DOC_transference_from_hash(input_transference:hash)
    @db_transaction_version = input_transference.clone
    missing_info_errors = self.verify_errors_fields(input_transference: input_transference)
    message = ''
    current_hour_in_integer = Time.now.strftime("%H").to_i
    if missing_info_errors != nil
      return missing_info_errors
    else
      if self.transaction_is_for_now(input_transference:input_transference)
        @db_transaction_version["status"] = 1
        if self.is_business_day(date:Date.today,hour: current_hour_in_integer)
          @db_transaction_version["selected_date"] = Date.today + 1.day
          @db_transaction_version["hour"] = self.get_closest_business_hour(current_hour_in_integer)
          message =  'Transferência por DOC realizada com sucesso, o valor será enviado em no mínimo uma hora'
        else
          @db_transaction_version["selected_date"] = self.get_closest_business_day(Date.today + 1.day)
          @db_transaction_version["hour"] = self.get_closest_business_hour(current_hour_in_integer)
          message = 'A transferência DOC não pode ser efetuada para hoje, ela será efetuada no próximo dia util'
        end
      else
        @db_transaction_version["status"] = 1
        selected_hour = @db_transaction_version["hour"].to_i
        current_date = Date.today
        begin
          selected_date = Date.parse(@db_transaction_version["selected_date"])
        rescue
          return "Data informada com problema"
        end

        if selected_date < current_date
          return "#{selected_date} é antes do dia de hoje, escolha uma data válida."
        end
        if self.is_business_day(date:selected_date,hour: selected_hour)
          @db_transaction_version["selected_date"] = selected_date
          @db_transaction_version["hour"] = self.get_closest_business_hour(selected_hour)
          message =  'Transferência por DOC agendada com sucesso, o valor será enviado em no um dia'
        else
          @db_transaction_version["selected_date"] = self.get_closest_business_day(selected_date)
          @db_transaction_version["hour"] = self.get_closest_business_hour(selected_hour)
          message = 'A transferência DOC não pode ser efetuada para o dia selecionado, ela será efetuada no próximo dia util'
        end
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
    def self.is_business_day(date:Date, hour:Integer)
      if date.wday == 0 or date.wday == 6
        return false
      elsif date.wday == 0 and self.is_business_hour(hour:hour) == 1
        return false
      else
        return true
      end
    end

  def self.is_business_hour(hour:Integer)
    if hour > 18
      return 1
    elsif hour < 8
      return -1
    else
      return 0
    end
  end

  def self.get_closest_business_hour(hour)
    is_business_hour_info = is_business_hour(hour:hour)
    if is_business_hour_info == 0
      return hour
    elsif is_business_hour_info == -1
      return 8
    else
      return 8
    end
  end

  def self.get_closest_business_day(date)
    if Date.parse(date).wday == 0 # sabado
      return date + 1.day
    elsif Date.parse(date).wday == 6 # domingo
      return date + 2.day
    elsif Date.parse(date).wday == 5 #sexta
      return date + 3.day
    else
      return date + 1.day
    end
  end

  def get_scheduled_transferences
    self.where()
  end
end
