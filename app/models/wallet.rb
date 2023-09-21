# frozen_string_literal: true

# == Schema Information
#
# Table name: wallets
#
#  id                 :uuid             not null, primary key
#  user_id            :uuid             not null
#  credit_in_cents    :integer          default(0)
#  debit_in_cents     :integer          default(0)
#  overdraft_in_cents :integer          default(0)
#  uniq_code          :string           not null
#  status             :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Wallet < ApplicationRecord
  belongs_to :user
  has_many :wallet_transactions
end
