# frozen_string_literal: true

class PesaController < ApplicationController
  # noinspection RailsParamDefResolve
  skip_before_action :doorkeeper_authorize!

  def validate
    render json: { success: :ok }
  end

  def confirm
    render json: { success: :ok }
  end

  def queue_timeout
    render json: { success: :ok, params: }
  end

  def result
    render json: { success: :ok, params: }
  end

  def call_back
    amount, phonenumber = nil

    return unless params[:Body][:stkCallback][:CallbackMetadata].present?

    params[:Body][:stkCallback][:CallbackMetadata][:Item].each do |item|
      case item[:Name].downcase
      when 'amount'
        amount = item[:Value]
      when 'phonenumber'
        phonenumber = item[:Value]
      end
    end

    wallet_id = find_wallet(phonenumber)
    credit_wallet_txn(wallet_id, amount, phonenumber, params)

    render json: 'received'
  end

  def pesa_token
    token = Stk::AccessToken.call(ENV['key'], ENV['secret'])
    render json: { token: token }
  end

  def send_money
    current_wallet = current_user.wallet_id
    SendMoney.send_funds(params[:amount], params[:recipient], current_wallet)

    render json: { message: 'request received for processing, do wait ...' }, status: :ok
  end

  private

  def find_wallet(phonenumber)
    User.find_by(phone: phonenumber).wallet.id
  end

  def credit_wallet_txn(wallet_id, amount, phonenumber, params)
    WalletTransaction.create({
                               wallet_id: wallet_id,
                               amount_in_cents: (amount.to_i * 100),
                               txn_type: 'credit',
                               phone: phonenumber,
                               result: params
                             })
    CreditJob.perform_now(wallet.id)
  end
end
