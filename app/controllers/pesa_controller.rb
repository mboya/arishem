# frozen_string_literal: true

class PesaController < ApplicationController
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
    render json: { success: :ok, params: }
  end

  def pesa_token
    token = Stk::AccessToken.call(ENV['key'], ENV['secret'])
    render json: { token: token }
  end
end
