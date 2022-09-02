module Accounting
  module Repositories
    class CatToy < ROM::Repository[:cat_toys]
      commands :create

      def find(id)
        cat_toys.by_pk(id).one!
      end
    end
  end
end
