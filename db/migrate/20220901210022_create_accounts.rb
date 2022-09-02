# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :accounts do
      primary_key :id

      # Accounting::Entities::Account
      column :point, Integer, null: false
      column :state, String, null: false

      # ToyTesting::Entities::Account
      column :toys_count, Integer, null: false
    end
  end
end
