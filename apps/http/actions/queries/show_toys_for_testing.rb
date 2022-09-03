require 'json'
require 'hanami/action'

module HTTP
  module Actions
    module Queries
      class ShowToysForTesting < Hanami::Action
        include Dry::Monads[:result]

        include Import[
          configuration: 'hanami.action.configuration',
          query: 'contexts.toy_testing.queries.all_toys_for_testing_query'
        ]

        def handle(_req, res)
          result = query.call

          case result
          in Success
            res.status  = 200
            res.body = result.value!.map do |toy|
              { id: toy[:id], negative: toy[:false], type: toy[:characteristic_type]}
            end
          in Failure[_, error_message]
            halt 422, error_message.to_json
          end
        end
      end
    end
  end
end
