require 'json'
require 'hanami/action'

module HTTP
  module Actions
    module Commands
      class AssignToy < Hanami::Action
        include Dry::Monads[:result]

        include Import[
          configuration: 'hanami.action.configuration',
          command: 'contexts.toy_testing.commands.assign_toy'
        ]

        def handle(req, res)
          result = command.call(account_id: req.params[:account_id].to_i, cat_toy_id: req.params[:id].to_i)

          case result
          in Success
            res.status  = 200
            res.body = {
              id: result.value!.id,
              toys_count: result.value!.toys_count,
              toys_ids: result.value!.toys_ids
            }.to_json
          in Failure[:account_not_founded, error_message]
            halt 404, error_message.to_json
          in Failure[_, error_message]
            halt 422, error_message.to_json
          end
        end
      end
    end
  end
end