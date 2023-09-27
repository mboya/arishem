# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  phone                  :string           not null
#  country_code           :string
#  first_name             :string
#  last_name              :string
#  status                 :boolean          default(TRUE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :country_code, presence: true
  validates :phone, phone: true

  has_one :wallet

  after_commit :create_wallet

  def self.authenticate(tone, password)
    user = User.find_for_authentication(email: tone) || User.find_for_authentication(phone: tone)
    user&.valid_password?(password) ? user : nil
  end

  def purse
    {
      credit: wallet&.credit_in_cents,
      debit: wallet&.debit_in_cents,
      overdraft: wallet&.overdraft_in_cents
    }
  end

  private

  def create_wallet
    wallet = Wallet.create({
                             user: self
                           })
    credit_joining_bonus(wallet)
  end

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
