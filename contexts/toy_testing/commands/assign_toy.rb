module ToyTesting
  module Commands
    class AssignToy
      include Import[cat_toys_repo: 'persistance.toy_testing.repositories.cat_toy.rom']

      def call
        cat_toys_repo.find(2)
      end
    end
  end
end