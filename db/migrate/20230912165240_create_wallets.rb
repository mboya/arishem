# frozen_string_literal: true

class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :credit_in_cents, default: 0
      t.integer :debit_in_cents, default: 0
      t.integer :overdraft_in_cents, default: 0
      t.string :uniq_code, default: -> { 'md5((random())::text)' }, null: false, unique: true
      t.boolean :status, default: true

      t.timestamps
    end

    execute <<-SQL
      alter table wallets add constraint credit_in_cents check (credit_in_cents >= 0);
      alter table wallets add constraint debit_in_cents check (debit_in_cents >= 0);
      alter table wallets add constraint overdraft_in_cents check (overdraft_in_cents >= 0);
    SQL
  end
end
