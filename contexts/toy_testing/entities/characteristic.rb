module ToyTesting
  module Entities
    class Characteristic < Dry::Struct
      transform_keys(&:to_sym)

      attribute :characteristic_type, ToyTesting::Types::CharacteristicTyppes
      attribute :value, ToyTesting::Types::String.constrained(max_size: 8, format: /[a-z, 0-9]/)
      attribute :comment, ToyTesting::Types::String.constrained(max_size: 255)
      attribute :will_recommend, ToyTesting::Types::Bool
    end
  end
end
