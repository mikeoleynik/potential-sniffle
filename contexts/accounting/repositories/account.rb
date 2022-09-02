module Accounting
  module Repositories
    class Account < ROM::Repository[:accounts]
      commands :create, update: :by_pk

      def find(id)
        accounts.by_pk(id).one
      end
    end
  end
end
