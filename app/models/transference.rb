class Transference < ApplicationRecord
  def self.verify_errors_fields(input_transference:hash)
    if input_transference["value"] == nil
      return 'Valor da transferência faltando'
    end
    return nil
  end
  def self.create_transference_from_hash(input_transference:hash)
    error = self.verify_errors_fields(input_transference: input_transference)
    if error != nil
      return error
    else
      @transference = Transference.new(input_transference)
      @transference.save
      return 'Transferência por PIX agendada com sucesso'
      # 'Transferência por PIX realizada com sucesso'
    end
  end

  # def get_scheduled_transferences
  #   self.where()
  # end
end
