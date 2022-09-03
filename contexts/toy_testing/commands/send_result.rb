module ToyTesting
  module Commands
    class SendResult
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[
        account_repo: 'persistance.toy_testing.repositories.account.rom',
        cat_toys_repo: 'persistance.toy_testing.repositories.cat_toy.rom'
      ]

      def call(params)
        account = yield find_account(params[:account_id])
        cat_toy = yield find_toy(params[:cat_toy_id])

        yield validate_toy(cat_toy)
        yield save_cat_toy(cat_toy, params)

        Success(account)
      end

      private

      def find_account(account_id)
        account = account_repo.find(account_id)

        if account
          Success(account)
        else
          Failure([:account_not_founded, { error: 'account_not_founded', account_id: account_id }])
        end
      end

      def find_toy(toy_id)
        cat_toy = cat_toys_repo.find(toy_id)

        if cat_toy
          Success(cat_toy)
        else
          Failure([:toy_not_founded, { error: 'toy_not_founded', cat_toy_id: toy_id }])
        end
      end

      def validate_toy(toy)
        if toy.tested
          Failure([:already_tested, { error: 'already_tested', cat_toy_id: toy.id }])
        elsif toy.negative
          Failure([:negative_characteristics, { error: 'negative_characteristics', cat_toy_id: toy.id }])
        else
          Success(toy)
        end
      end

      def save_cat_toy(cat_toy, params)
        attributes = prepare_attributes(params.merge(id: cat_toy.id, tested: true))
        Success(cat_toys_repo.update(cat_toy.id, attributes))
      end

      def prepare_attributes(attributes)
        ToyTesting::Entities::CatToy.new(attributes)
      end
    end
  end
end


