# frozen_string_literal: true

class SendMoney

  class << self
    def send_funds(amount, recipient, sender)
      new(amount, recipient, sender).process_funds
    end
  end

  attr_reader :amount, :recipient, :sender

  def initialize(amount, recipient, sender)
    @amount = amount.to_i
    @recipient = recipient # this is going to be the receiving wallet
    @sender = sender
  end

  def process_funds
    return unless check_wallet

    debit
    credit
  end

  private

  def check_wallet
    Wallet.find_by(id: sender).credit_in_cents >= (amount * 100)
  end

  def wallet_transaction
    WalletTransaction
  end

  def debit
    wallet_transaction.create({
                                wallet: sender,
                                amount_in_cents: -(amount * 100),
                                txn_type: 'debit'
                              })
    DebitJob.perform_now(sender)
  end

  def credit
    wallet_transaction.create({
                                wallet: recipient,
                                amount_in_cents: (amount * 100),
                                txn_type: 'credit'
                              })
    CreditJob.perform_now(recipient)
  end

  def outbound_funds
    receiver = Wallet.find(recipient).user.phone
    Stk::B2c.send_funds(amount, receiver)
    # since am plugged into daraja api, will send out funds to user phone number

    # run the notifier job/client
  end

end
