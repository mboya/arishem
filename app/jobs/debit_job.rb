# frozen_string_literal: true

class DebitJob < ApplicationJob
  queue_as :debit

  def perform(wallet_id)
    sum_debit_values(wallet_id)
  end

  private

  def sum_debit_values(wallet_id)
    sum_amount = WalletTransaction.where(wallet_id: wallet_id).sum(:amount_in_cents)
    Wallet.find(wallet_id).update(debit_in_cents: sum_amount)
  end
end
