require 'rom-repository'

module ToyTesting
  module Repositories
    class Account < ROM::Repository[:accounts]
      commands :create

      def find(id)
        accounts.by_pk(id).one!
      end
    end
  end
end