module Accounting
  module Entities
    class Account < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, Accounting::Types::Integer

      attribute :point, Accounting::Types::Integer
      attribute :state, Accounting::Types::AccountStatuses
    end
  end
end
