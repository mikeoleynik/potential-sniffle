module ToyTesting
  module Queries
    class AllToysForTestingQuery
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[cat_toy_repo: 'persistance.toy_testing.repositories.cat_toy.rom']

      def call
        cat_toys = cat_toy_repo.all_toys_for_testing

        if cat_toys
          Success(cat_toys)
        else
          Failure([:cat_toys_not_founded, { error: 'cat_toys_not_founded' }])
        end
      end
    end
  end
end
