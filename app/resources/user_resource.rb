# frozen_string_literal: true

# class UserResource
class UserResource < JSONAPI::Resource
  caching
  attributes :phone, :country_code, :names, :first_name, :last_name, :status, :email, :password, :wallet

  after_create :create_wallet

  def fetchable_fields
    super - %i[first_name last_name status country_code email password]
  end

  def names
    "#{@model.last_name}, #{@model.first_name}"
  end

  def wallet
    @model.purse
  end

  def create_wallet
    wallet = Wallet.create({
                             user: @model
                           })
    credit_joining_bonus(wallet)
  end

  private

  def credit_joining_bonus(wallet)
    # going to credit kes 50 into the new user account
    # create a wallet credit transaction

    WalletTransaction.create({
                               wallet: wallet,
                               amount_in_cents: (50 * 100),
                               txn_type: 'credit',
                               phone: @model.phone
                             })
    CreditJob.perform_now(wallet.id)
  end
end
