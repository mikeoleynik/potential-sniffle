module ToyTesting
  module Entities
    class CatToy < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, ToyTesting::Types::Integer

      attribute :account_id, ToyTesting::Types::Integer
      attribute :comment, ToyTesting::Types::String.constrained(max_size: 255).default(''.freeze)
      attribute :tested, ToyTesting::Types::Bool.default(false)
      attribute :negative, ToyTesting::Types::Bool.default(false)

      attribute :characteristic_type, ToyTesting::Types::CharacteristicTyppes
      attribute :value, ToyTesting::Types::String.constrained(max_size: 8, format: /[a-z, 0-9]/)
    end
  end
end
