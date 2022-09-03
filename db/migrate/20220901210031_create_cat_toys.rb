# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :cat_toys do
      primary_key :id

      column :account_id, Integer, null: false
      column :comment, String, null: false
      column :tested, TrueClass, null: false
      column :negative, TrueClass, null: false

      column :characteristic_type, String
      column :value, String
    end
  end
end
