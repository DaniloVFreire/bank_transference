class TransferencesController < ApplicationController
  before_action :set_transference, only: %i[ update destroy]
  def index
    @transferences = Transference.all
    render json: @transferences
  end
  def show
    @transference = Transference.where(origin_account:params[:origin_account])
    render json:@transference
  end
  def show_all_transferences
    @transference = Transference.where(origin_account: params[:account_or_pix_key]).
      or(Transference.where(target_account_or_pix_key: params[:account_or_pix_key]))
    render json:@transference
  end
  def show_made_transferences
    @transference = Transference.where(origin_account: params[:origin_account])
    render json:@transference
  end
  def show_recived_transferences
    @transference = Transference.where(target_account_or_pix_key: params[:account_or_pix_key])
    render json:@transference
  end
  def create
    puts "create with post route"
    transfer_data = JSON.parse(request.body.read)
    origin_account = transfer_data['origin_account']
    target_account = transfer_data['target_account']
    value = transfer_data['value'].to_f
    transference_type = transfer_data['transference_type']

    #@target_account_exist = AccountApiService.check_target_account(target_account)
    have_balance_to_transfer = AccountApiService.check_balance(origin_account, value)

    if have_balance_to_transfer == 0
      if transference_type == 1
        creation_result = Transference.create_transference_from_hash(input_transference: transfer_data)
        render json: { message: creation_result }
      elsif transference_type == 2
        render json: { message: 'Transferência por TED realizada com sucesso, o valor será enviado em no mínimo uma hora' }
      elsif transference_type == 3
        render json: { message: 'Transferência por DOC iniciada, o valor será enviado no próximo dia útil' }
      else
        render json: { error: 'Tipo de transferência não suportada' }, status: :unprocessable_entity
      end
    elsif have_balance_to_transfer == 2
      render json: { error: 'falha ao acessar api de conta' }, status: :not_found
    else 
      render json: { error: 'Saldo insuficiente para realizar a transferência' }, status: :unprocessable_entity
    end
  end
  def destroy
    @transference.destroy
  end
  private
    def set_transference
      @transference = Transference.find(params[:id])
    end
    def transference_params
      params.require(:transference).permit(:value, :selected_date, :hour, :origin_account, :status, :target_account_or_pix_key, :transference_type)
    end
end
