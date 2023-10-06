# frozen_string_literal: true

# Pesa Controller
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
    return unless params[:Body][:stkCallback][:CallbackMetadata].present?

    Receipt.receive_funds(params)
    render json: :ok
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
end
