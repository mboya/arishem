# frozen_string_literal: true

class OverdraftJob < ApplicationJob
  queue_as :overdraft

  def perform(*args)
    sum_overdraft_values(wallet_id)
  end

  private

  def sum_overdraft_values(wallet_id)
    sum_amount = WalletTransaction.where(wallet_id: wallet_id).sum(:amount_in_cents)
    Wallet.find(wallet_id).update(overdraft_in_cents: sum_amount)
  end
end
