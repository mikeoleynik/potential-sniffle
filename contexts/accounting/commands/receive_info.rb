module Accounting
  module Commands
    class ReceiveInfo
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[
        account_repo: 'persistance.accounting.repositories.account.rom',
        cat_toy_repo: 'persistance.toy_testing.repositories.cat_toy.rom'
      ]

      def call(params)
        account = yield find_account(params[:account_id])
        cat_toy = yield find_toy(params[:cat_toy_id])

        yield validate_account(account)
        yield validate_toy(cat_toy)
        yield assign_points(account)

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
        cat_toy = cat_toy_repo.find(toy_id)

        if cat_toy
          Success(cat_toy)
        else
          Failure([:toy_not_founded, { error: 'toy_not_founded', cat_toy_id: toy_id }])
        end
      end

      def validate_account(account)
        if account.state == 'blocked'
          Failure([:account_is_blocked, { error: 'account_is_blocked', account_id: account_id }])
        else
          Success(account)
        end
      end

      def validate_toy(toy)
        if toy.tested
          Success(toy)
        else
          Failure([:no_testing, { error: 'no_testing', cat_toy_id: toy.id }])
        end
      end

      def assign_points(account)
        points = account.point + 1000
        Success(account_repo.update(account.id, point: points))
      end
    end
  end
end
