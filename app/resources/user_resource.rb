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
    {
      credit: '0'.to_i ||= @model.wallet.credit_in_cents,
      debit: '0'.to_i ||= @model&.wallet&.debit_in_cents,
      overdraft: '0'.to_i ||= @model&.wallet&.overdraft_in_cents,
    }
  end

  def create_wallet
    wallet = Wallet.create({
                             user: @model
                           })
    credit_joining_bonus(wallet)
  end

  private

  def credit_joining_bonus(wallet)
    wallet.update({ credit_in_cents: 50 * 100 }) # crediting kes 50 to user account for joining platform
    # send notification to client
  end
end
