module ToyTesting
  module Repositories
    class CatToy < ROM::Repository[:cat_toys]
      commands :create, update: :by_pk

      def find(id)
        cat_toys.by_pk(id).one
      end
    end
  end
end