# frozen_string_literal: true

# Receipt
class Receipt
  class << self
    def receive_funds(params)
      new(params).process_incoming_funds
    end
  end

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def process_incoming_funds
    params[:Body][:stkCallback][:CallbackMetadata][:Item].each(&method(:amount_phone_extract))
  end

  private

  def amount_phone_extract(item)
    case item[:Name].downcase
    when 'amount'
      @amount = item[:Value]
    when 'phonenumber'
      @phone = item[:Value]
    else
      # type code here
    end
  end

  def find_wallet
    User.find_by(phone: @phone).wallet_id
  end

  def credit_wallet_txn
    wallet_id = find_wallet

    WalletTransaction.create({
                               wallet_id: wallet_id,
                               amount_in_cents: (@amount.to_i * 100),
                               txn_type: 'credit',
                               phone: @phone
                             })
    CreditJob.perform_now(wallet.id)
  end

end
