module ToyTesting
  module Entities
    class Account < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, ToyTesting::Types::Integer

      attribute :toys_count, ToyTesting::Types::Integer.constrained(lteq: 3).default(0)
    end
  end
end
