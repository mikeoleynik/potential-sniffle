module Accounting
  class Types
    include Dry.Types()

    AccountStatuses = Types::String.default('active'.freeze).enum('blocked', 'active')
  end
end