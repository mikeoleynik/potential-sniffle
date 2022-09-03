module ToyTesting
  module Commands
    class AssignToy
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[account_repo: 'persistance.toy_testing.repositories.account.rom']

      def call(params)
        account = yield find_account(params[:account_id])

        yield validate_account(account)

        yield assign_toy(account, params[:cat_toy_id])

        Success(account)
      end

      private

      def find_account(account_id)
        account = account_repo.find(account_id)

        if account
          Success(account)
        else
          Failure([:account_not_founded, { account_id: account_id }])
        end
      end

      def validate_account(account)
        if account.toys_count > 3
          Failure([:many_toys, { account_id: account.id }])
        else
          Success(account)
        end
      end

      def assign_toy(account, toy_id)
        ids = (account.toys_ids || []) + [toy_id]
        toys_count = account.toys_count + 1

        if toys_count > 3
          Failure([:many_toys, { toy_id: toy_id }])
        else
          Success(account_repo.update(account.id, toys_ids: ids.uniq, toys_count: toys_count))
        end
      end
    end
  end
end