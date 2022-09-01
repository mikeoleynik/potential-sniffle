module ToyTesting
  module Entities
    class CatToy < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, ToyTesting::Types::Integer

      attribute :account_id, ToyTesting::Types::Integer
      attribute :comment, ToyTesting::Types::String.constrained(max_size: 255).default(''.freeze)
      attribute :tested, ToyTesting::Types::Bool.default(false)
      attribute :negative, ToyTesting::Types::Bool
      attribute :characteristics, ToyTesting::Types::CatToyCharacteristics
    end
  end
end



