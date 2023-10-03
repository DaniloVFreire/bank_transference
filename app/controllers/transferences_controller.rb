class TransferencesController < ApplicationController

  def create
    puts "create with post route"
    transfer_data = JSON.parse(request.body.read)
    origin_account = transfer_data['origin_account']
    target_account = transfer_data['target_account']
    value = transfer_data['value'].to_f
    transference_type = transfer_data['transference_type']

    #@target_account_exist = AccountApiService.check_target_account(target_account)
    can_transfer = AccountApiService.check_balance(origin_account, value)

    if can_transfer == 0
      if transference_type == 1
        @transference = Transference.new(transfer_data)
        @transference.save
        render json: { message: 'Transferência por PIX realizada com sucesso' }
      elsif transference_type == 2
        render json: { message: 'Transferência por TED realizada com sucesso, o valor será enviado em no mínimo uma hora' }
      elsif transference_type == 3
        render json: { message: 'Transferência por DOC iniciada, o valor será enviado no próximo dia útil' }
      else
        render json: { error: 'Tipo de transferência não suportada' }, status: :unprocessable_entity
      end
    elsif can_transfer == 2
      render json: { error: 'falha ao acessar api de conta' }, status: :not_found
    else 
      render json: { error: 'Saldo insuficiente para realizar a transferência' }, status: :unprocessable_entity
    end
  end
  def index
    render json: Transference.all
  end
end
