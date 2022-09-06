module ToyTesting
  module Repositories
    class CatToy < ROM::Repository[:cat_toys]
      commands :create, update: :by_pk

      def find(id)
        cat_toys.by_pk(id).one
      end

      def all_toys_for_testing
        cat_toys.where(tested: false)
      end
    end
  end
end