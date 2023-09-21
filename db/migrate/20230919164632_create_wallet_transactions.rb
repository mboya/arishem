# frozen_string_literal: true

class CreateWalletTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :wallet_transactions, id: :uuid do |t|
      t.references :wallet, null: false, foreign_key: true, type: :uuid
      t.integer :amount_in_cents
      t.string :txn_type
      t.string :phone
      t.jsonb :result

      t.timestamps
    end

    add_index :wallet_transactions, :txn_type
    add_index :wallet_transactions, :phone
    add_index :wallet_transactions, :result
  end
end
