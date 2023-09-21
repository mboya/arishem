# frozen_string_literal: true

# == Schema Information
#
# Table name: wallet_transactions
#
#  id              :uuid             not null, primary key
#  wallet_id       :uuid             not null
#  amount_in_cents :integer
#  txn_type        :string
#  phone           :string
#  result          :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class WalletTransaction < ApplicationRecord
  belongs_to :wallet
end
