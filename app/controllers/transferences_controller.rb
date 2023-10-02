class TransferencesController < ApplicationController

  def create
    transfer_data = JSON.parse(request.body.read)
    origin_account = transfer_data['origin_account']
    target_account = transfer_data['target_account']
    value = transfer_data['value'].to_f
    type = transfer_data['type']

    #@target_account_exist = AccountApiService.check_target_account(target_account)
    @can_transfer = AccountApiService.check_balance(origin_account, value)

    if can_transfer
      if type == 1
        render json: { message: 'Transferência por PIX realizada com sucesso' }
      elsif type == 2
        render json: { message: 'Transferência por TED realizada com sucesso' }
      elsif type == 3
        render json: { message: 'Transferência por DOC realizada com sucesso' }
      end
    
    else 
      render json: { error: 'Saldo insuficiente para realizar a transferência' }, status: :unprocessable_entity
    
    end

  end


end
