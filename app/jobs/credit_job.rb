# frozen_string_literal: true

class CreditJob < ApplicationJob
  queue_as :credit

  def perform(wallet_id)
    sum_credit_values(wallet_id)
  end

  private

  def sum_credit_values(wallet_id)
    sum_amount = WalletTransaction.where(wallet_id: wallet_id).sum(:amount_in_cents)
    Wallet.find(wallet_id).update(credit_in_cents: sum_amount)
  end
end
